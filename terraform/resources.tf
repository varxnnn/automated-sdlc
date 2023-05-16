terraform {
  backend "s3" {
    bucket = "major-project-terraform-state-automated-sdlc"
    key    = "terraform.tfstate"
    region = "ap-south-1"
    # access_key = var.access_key
    # secret_key = var.secret_key
    profile = "default"
  }
}

resource "aws_instance" "ec2_instance" {
    ami = var.ami_id
    subnet_id = aws_subnet.public_subnet.id
    instance_type = var.instance_type
    key_name = var.ami_key_pair_name
    associate_public_ip_address = true
    vpc_security_group_ids = [ "${aws_security_group.public_sg1.id}" ]
    user_data = file("${path.module}/bootstrap/script.sh")
    
    # connection {
    #   type = "ssh"
    #   user = "ec2-user"
    #   private_key = file("${path.module}/tf_test.pem")
    #   host = self.public_ip
    # }

    # provisioner "remote-exec" {
    #     inline = [ 
    #         "sudo yum -y install docker", 
    #         "sudo usermod -a -G docker ec2-user", 
    #         "sudo systemctl start docker",
    #         "whoami",
    #         "docker run -d --name nexus --restart unless-stopped -p 8081:8081 -v nexus-data:/nexus-data sonatype/nexus3" 
    #     ]
    # }
} 

resource "aws_vpc" "test_vpc" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet" {
    vpc_id     = aws_vpc.test_vpc.id
    cidr_block = "10.0.0.0/20"
    availability_zone = "ap-south-1a"
}

resource "aws_internet_gateway" "test_gw" {
    vpc_id = aws_vpc.test_vpc.id
}

resource "aws_route_table" "public_rtb" {
    vpc_id = aws_vpc.test_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.test_gw.id
    }
}

resource "aws_route_table_association" "public_rtb_association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rtb.id
}

resource "aws_security_group" "public_sg1" {    
    name = "test_sg_1"
    description = "allow http, ssh"
    vpc_id = aws_vpc.test_vpc.id

    ingress { 
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress { 
        description = "HTTP"
        from_port = 8081
        to_port = 8081
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"] 
    }

    tags = {
      Name = "testing_securitygroup"
    }
}

output "public_dns_address" {
  value = aws_instance.ec2_instance.public_ip
}