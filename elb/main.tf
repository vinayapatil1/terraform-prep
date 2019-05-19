provider "aws" {
  region = "us-east-1"
}

resource "aws_elb" "elb_trial" {
  name               = "foobar-terraform-elb"
  availability_zones = ["us-east-1b"]

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
    }

  instances                   = ["${aws_instance.web.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}
 
 resource "aws_instance" "web" {
  instance_type = "t2.micro"
  ami = "ami-0756fbca465a59a30"
  count = 3
  }

  
