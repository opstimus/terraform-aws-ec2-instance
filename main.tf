resource "aws_security_group" "main" {
  count       = length(var.ingress_rules) > 0 ? 1 : 0
  name        = "${var.project}-${var.environment}-${var.name}"
  description = "${var.project}-${var.environment}-${var.name}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  # All traffic enabled for outbound. Restrict if required
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.project}-${var.environment}-${var.name}"
  }
}

resource "aws_instance" "main" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = length(var.ingress_rules) > 0 ? [aws_security_group.main[0].id] : var.security_group_ids
  source_dest_check      = var.source_dest_check
  subnet_id              = var.subnet_id
  key_name               = var.key_name != null ? var.key_name : null

  root_block_device {
    delete_on_termination = true
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    encrypted             = true
  }

  user_data_replace_on_change = true
  user_data                   = var.user_data

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    "Name" = "${var.project}-${var.environment}-${var.name}"
  }
}

resource "aws_eip" "main" {
  tags = {
    "Name" = "${var.project}-${var.environment}-${var.name}"
  }
}

resource "aws_eip_association" "main" {
  count         = var.enable_eip ? 1 : 0
  instance_id   = aws_instance.main.id
  allocation_id = aws_eip.main.id
}
