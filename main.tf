provider "aws" {
  region = "ap-south-2"
}

resource "aws_vpc" "jenkinsvpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    "Name" = var.vpc_name
  }
}

resource "aws_internet_gateway" "JenkinsIGW" {
  vpc_id = aws_vpc.jenkinsvpc.id
  tags = {
    "Name" = "${var.vpc_name}-IGW"
  }
}

resource "aws_subnet" "JenkinsPublicSubnet" {
  count                   = length(var.publicsubnetcidr)
  vpc_id                  = aws_vpc.jenkinsvpc.id
  cidr_block              = element(var.publicsubnetcidr, count.index)
  availability_zone       = element(var.az, count.index)
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${var.vpc_name}-Public-Subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "JenkinsPublicRTB" {
  vpc_id = aws_vpc.jenkinsvpc.id
  tags = {
    "Name" = "${var.vpc_name}-PublicRTB"
  }
  route {
    gateway_id = aws_internet_gateway.JenkinsIGW.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "jenkinspublicrouteassociate" {
  count          = length(var.publicsubnetcidr)
  route_table_id = aws_route_table.JenkinsPublicRTB.id
  subnet_id      = element(aws_subnet.JenkinsPublicSubnet.*.id, count.index)
}

resource "aws_security_group" "demofunctionssg" {
  vpc_id = aws_vpc.jenkinsvpc.id
  name   = "websecurity"
  tags = {
    "Name" = "${var.vpc_name}-SG"
  }
  description = "allowing web server ports"
  dynamic "ingress" {
    for_each = local.ingress_rule1
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  dynamic "ingress" {
    for_each = local.ingress_rule2
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "JenkinsInstance" {
  count                       = var.env == "Dev" ? 3 : 1
  ami                         = var.ami
  key_name                    = var.key_name
  instance_type               = var.type
  subnet_id                   = element(aws_subnet.JenkinsPublicSubnet.*.id, count.index)
  vpc_security_group_ids      = [aws_security_group.demofunctionssg.id]
  associate_public_ip_address = true
  tags = {
    "Name" = "${var.vpc_name}-Server-${count.index + 1}"
  }
}
