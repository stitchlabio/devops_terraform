provider "aws" {
    region = "ap-northeast-1"
}

resource "aws_vpc" "devops_vpc" {
    cidr_block = "10.100.0.0/16"
    tags = {
          Name = "${var.resource_tag}-vpc"
    }
}

resource "aws_subnet" "devops_vpc_pub_subnet_01" {
    cidr_block        = "10.100.1.0/24"
    availability_zone = "ap-northeast-1a"
    vpc_id            = "${aws_vpc.devops_vpc.id}"
    tags = {
          Name = "${var.resource_tag}-pub-subnet-01"
    }
}

resource "aws_subnet" "devops_vpc_pub_subnet_02" {
    cidr_block        = "10.100.2.0/24"
    availability_zone = "ap-northeast-1c"
    vpc_id            = "${aws_vpc.devops_vpc.id}"
    tags = {
          Name = "${var.resource_tag}-pub-subnet-02"
    }
}

resource "aws_internet_gateway" "devops_vpc_gw" {
  vpc_id = "${aws_vpc.devops_vpc.id}"
}

resource "aws_default_route_table" "devops_vpc_rt" {
  default_route_table_id = "${aws_vpc.devops_vpc.default_route_table_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.devops_vpc_gw.id}"
  }
}

resource "aws_route_table_association" "devops_vpc_rt_associate01" {
  subnet_id      = "${aws_subnet.devops_vpc_pub_subnet_01.id}"
  route_table_id = "${aws_vpc.devops_vpc.main_route_table_id}"
}

resource "aws_route_table_association" "devops_vpc_rt_associate02" {
  subnet_id      = "${aws_subnet.devops_vpc_pub_subnet_02.id}"
  route_table_id = "${aws_vpc.devops_vpc.main_route_table_id}"
}

resource "aws_security_group" "instance_sg" {
  description = "controls access to the application server"

  vpc_id = "${aws_vpc.devops_vpc.id}"
  name   = "${var.resource_tag}-sg"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_instance" "devops_test_server" {
  vpc_security_group_ids = ["${aws_security_group.instance_sg.id}"]

  key_name                    = "devops-tokyo-key"
  ami                    = "ami-0a85857bfc5345c38"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id = "${aws_subnet.devops_vpc_pub_subnet_01.id}"

  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "${var.resource_tag}-server"
 }

}