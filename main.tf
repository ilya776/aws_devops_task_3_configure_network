resource "aws_subnet" "grafana_subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "grafana"
  }
}

resource "aws_internet_gateway" "grafana_igw" {
  vpc_id = var.vpc_id
  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_route_table" "grafana_route_table" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.grafana_igw.id
  }

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_route_table_association" "grafana_subnet_association" {
  subnet_id      = aws_subnet.grafana_subnet.id
  route_table_id = aws_route_table.grafana_route_table.id
}


resource "aws_security_group" "grafana_sg" {
  vpc_id = var.vpc_id
  name   = "mate-aws-grafana-lab"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mate-aws-grafana-lab"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.grafana_sg.id
  from_port             = 22
  to_port               = 22
  ip_protocol           = "tcp"
  cidr_ipv4            = "104.28.131.185/32"

}


resource "aws_security_group_rule" "allow_all_egress" {
  type = "egress"
  security_group_id = aws_security_group.grafana_sg.id
  cidr_blocks         = ["0.0.0.0/0"]
  protocol       = -1

  from_port         = 0
  to_port           = 0
}

resource "aws_vpc_security_group_ingress_rule" "grafana_ingress_tcp_3000" {
  security_group_id = aws_security_group.grafana_sg.id
  cidr_ipv4            = "0.0.0.0/0"
  from_port             = 3000
  to_port               = 3000
  ip_protocol           = "tcp"
}

