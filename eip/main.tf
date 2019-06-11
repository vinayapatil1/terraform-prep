provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_eip" "lb" {
  instance = "${aws_instance.web.id}"
  vpc      = true
}

resource "aws_security_group" "default" {
  name        = "eip_example"
  description = "Used in the terraform"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  instance_type = "t2.micro"
  ami = "${lookup(var.aws_amis, var.aws_region)}"  
  security_groups = ["${aws_security_group.default.name}"]
  user_data = "${file("userdata.sh")}"

  #Instance tags
  tags = {
    Name = "eip-example"
  }
}
