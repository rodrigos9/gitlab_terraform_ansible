#!/bin/bash

vpc_id=`aws ec2 describe-vpcs |grep VpcId |head -n 1 |cut -d: -f2 |cut -d\" -f2`

aws ec2 create-tags --resources $vpc_id --tags Key=Name,Value=myvpc

subnet_id=`aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpc_id" |grep SubnetId |head -n 1 |cut -d: -f2 |cut -d\" -f2`

aws ec2 create-tags --resources $subnet_id --tags Key=Name,Value=mysubnet

printf '{"VpcId" : "%s"}\n' "$vpc_id"
printf '{"SubnetId" : "%s"}\n' "$subnet_id"
