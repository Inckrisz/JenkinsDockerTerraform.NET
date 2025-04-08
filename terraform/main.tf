provider "aws" {
  region = "eu-central-1"  
}

resource "aws_instance" "docker_instance" {
  ami           = "ami-0ecf75a98fe8519d7"
  instance_type = "t2.micro" 

  key_name      = "VM-Key" 
  
  security_groups = ["my_security_group"] 

  user_data = <<-EOF
            #!/bin/bash
            sudo yum update -y
            sudo yum install -y docker
            sudo systemctl enable docker
            sudo systemctl start docker
            sudo docker pull inckrisz/dotnet-webapi
            sudo docker run -d --restart=always -p 5324:5324 inckrisz/dotnet-webapi:latest
            EOF


    root_block_device {
    volume_size = 10          
    volume_type = "gp2"        
    delete_on_termination = true
  }

  tags = {
    Name = "DockerInstance"
  }
}

resource "aws_security_group" "my_security_group" {
  name = "my_security_group_${random_id.suffix.hex}"
  description = "Allow HTTP and SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5324
    to_port     = 5324
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
