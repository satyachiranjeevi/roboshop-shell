#!/bin/bash

NAMES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")
INSTANCE_TYPE=""
IMAGE_ID=ami-03265a0778a880afb
SECURITY_GROUP_ID=sg-08aad2e7512ca2cf6


# if mongodb, mysql then instance type should be t3.micro for rest all its t2.micro


for item in "${NAMES[@]}"
do
    if [ $item == "mongodb" || $item == "mysql" ]
    then
        INSTANCE_TYPE="t3.micro"
    else
        INSTANCE_TYPE="t2.micro"
    fi
    echo "Creating $item instance"

    aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids 
    $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=A-$item}]"
done