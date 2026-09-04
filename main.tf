




variable "aws_region" {
  description = "aws region name"
  type        = string
  default     = "ap-south-1"
}
variable "project_name" {
  description = "project name"
  type        = string
  default     = "zomato"
}
variable "project_environment" {
  description = "project environment"
  type        = string
  default     = "production"
}
provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.project_environment
    }
  }
}
resource "null_resource" "provision_ec2_on_userdata_change" {

  triggers = {
    userdata_change = filemd5("setup.sh")
  }

  provisioner "file" {

    source      = "./setup.sh"
    destination = "/tmp/setup.sh"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = aws_instance.webserver.public_ip
      port        = 22
      private_key = file("mykey-py.pem")
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/setup.sh",
      "sudo /tmp/setup.sh"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = aws_instance.webserver.public_ip
      port        = 22
      private_key = file("mykey-py.pem")
    }
  }
}
resource "aws_instance" "webserver" {

  ami                    = "ami-00d2dbb426772b03a"
  instance_type          = "t3.micro"
  key_name               = "mykey-py"
  vpc_security_group_ids = [ "sg-0e2e1087d6efe73fe" ]
  tags = {
    Name = "${var.project_name}-${var.project_environment}-webserver"
  }

  lifecycle {
    create_before_destroy = true
  }
}
