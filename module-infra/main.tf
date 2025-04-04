
resource "aws_security_group" "tool" {
  name = "${var.name}-sg"
  description = "${var.name} Security Group"
  tags = {
    Name = "${var.name}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.tool.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  to_port = 22
  description = "ssh"
}

resource "aws_vpc_security_group_ingress_rule" "app_port" {
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.tool.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = var.port
  to_port = var.port
  description = var.name
}

resource "aws_vpc_security_group_egress_rule" "egress_allow_all" {
  ip_protocol       = "-1"
  security_group_id = aws_security_group.tool.id
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_instance" "tool" {
  ami = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.tool.id]
  iam_instance_profile   = aws_iam_instance_profile.main.name

  root_block_device {
    volume_size = var.root_block_device
  }
  instance_market_options {
    market_type = "spot"
    spot_options {
      instance_interruption_behavior = "stop"
      spot_instance_type             = "persistent"
    }
  }
  tags = {
    Name = var.name
  }
}

resource "aws_route53_record" "private" {
  name    = "${var.name}-internal"
  type    = "A"
  zone_id = var.zone_id
  ttl = 10
  records = [aws_instance.tool.private_ip]
}

resource "aws_route53_record" "public" {
  name    = var.name
  type    = "A"
  zone_id = var.zone_id
  ttl = 10
  records = [aws_instance.tool.public_ip]
}