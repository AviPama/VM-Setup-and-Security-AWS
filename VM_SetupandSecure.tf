provider "aws" {
  region = "eu-north-1"  
}

resource "aws_security_group" "web_sg" {
  name        = "web-traffic-sg"
  description = "Allow HTTP and HTTPS traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebTrafficSG"
  }
}

resource "aws_instance" "my_instance" {
  ami           = "ami-094a9a574d190f541"  
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  monitoring = true

  tags = {
    Name = "MyInstance"
  }
}

resource "aws_cloudwatch_log_group" "vm_log_group" {
  name              = "/aws/ec2/my-instance"
  retention_in_days = 7
  tags = {
    Name = "MyInstanceLogs"
  }
}

resource "aws_cloudwatch_log_stream" "vm_log_stream" {
  name           = "my-instance-stream"
  log_group_name = aws_cloudwatch_log_group.vm_log_group.name
}
