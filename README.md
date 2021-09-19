# gitlab_terraform_ansible
# important informations : 
     - the config files are using us-east-1 aws region.
     - the size of instance that will be provisioned is t2.medium
     - the public ip of the machine that is terraform will be added to security group
     - dont forget to create a key-pair before terraform apply (the script is configured to get cat /etc/gitlab/initial_root_password instances.tf)
     - the gitlab version will be gitlab-ce
     - gitlab will be configured to use https and the security group will allow 443 from anywhere
     - there are 2 scripts public.sh (get your public IP to put in AWS SG) and vpc.sh (get your first available vpc and your 
     first availabe subnet inside the selected vpc and put  tags to terraform filter them) to run together with terraform
     - ansible inventory is dynamic and the path is ./ansible/inv_aws_ec2.yml
     - average deploy time is 11 min

1. First, we need to configure aws credentials.
#aws configure (programatic access)

2. Create a bucket to store terraform state file.
#aws s3api create-bucket --bucket <bucket_name>

3. Set the <bucket_name> in the file backend.tf (bucket = "<bucket_name>")

4. Change the path in security_groups.tf to the path of scripts public.sh and vpc.sh

5. Initialize terraform
#terraform init --reconfigure

6. Format terraform
#terraform fmt

7. Validate terraform
#terraform validate

8. Plan terraform
#terraform plan

9. Apply terraform
#terraform apply

#### Output:
aws_instance.gitlab (local-exec):             "external_url 'https://<your_instance_ip>.compute-1.amazonaws.com'"

### Initial root password ###
cat /etc/gitlab/initial_root_password
