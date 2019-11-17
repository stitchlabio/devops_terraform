provider "aws" {
    region = "ap-northeast-1"
}

resource "aws_instance" "example" {
    ami = "ami-0f9af249e7fa6f61b" #ubuntu1604
    instance_type = "t2.micro"
    
    tags = {
        Name = "${var.instance_tag}"
    }

}
