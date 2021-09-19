#Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "linuxAmi" {
  provider = aws.region-master
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_subnet" "selected" {
  depends_on = [
    null_resource.script
  ]
  provider = aws.region-master
  filter {
    name   = "tag:Name"
    values = ["mysubnet"]
  }
}

#Please note that this code expects SSH key pair to exist in default dir under
#users home directory, otherwise it will fail

#Create key-pair for logging into EC2 in us-east-1
resource "aws_key_pair" "gitlab-key" {
  provider   = aws.region-master
  key_name   = "gitlab"
  public_key = file("/root/.ssh/id_rsa.pub")
}

#Create and bootstrap EC2 in us-east-1
resource "aws_instance" "gitlab" {
  provider                    = aws.region-master
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.gitlab-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.gitlab-sg.id]
  subnet_id                   = data.aws_subnet.selected.id

  tags = {
    Name = "gitlab_tf"
  }

  provisioner "local-exec" {
    command = <<EOF
aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-master} --instance-ids ${self.id}
ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible/install_gitlab.yml
EOF
  }

}