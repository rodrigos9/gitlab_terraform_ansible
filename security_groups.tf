data "external" "public_ip" {
  program = ["bash", "<path>/public.sh"]
}

resource "null_resource" "script" {
  provisioner "local-exec" {
    command     = "<path>/vpc.sh"
    interpreter = ["/bin/bash"]
  }
}

data "aws_vpc" "selected" {
  depends_on = [
    null_resource.script
  ]
  provider = aws.region-master
  filter {
    name   = "tag:Name"
    values = ["myvpc"]
  }
}

#Create SG for LB, only TCP/80,TCP/443 and outbound access
resource "aws_security_group" "gitlab-sg" {
  provider    = aws.region-master
  name        = "gitlab-sg"
  description = "Allow 443 and traffic to Jenkins SG"
  vpc_id      = data.aws_vpc.selected.id
  ingress {
    description = "Allow 443 from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow 22 from our public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.external.public_ip.result.public_ip}/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
