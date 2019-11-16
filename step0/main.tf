provider "aws" {
    region = "us-west-2"
}

resource "aws_instance" "example" {
    ami = "ami-0a85857bfc5345c38"
    instance_type = "t2.micro"
    
    tags = {
        Name = "${var.instance_tag}"
    }

}
