#!/bin/bash

NAMES=$@
INSTANCE_TYPE=""
IMAGE_ID=ami-03265a0778a880afb
SECURITY_GROUP_ID=sg-08aad2e7512ca2cf6
DOMAIN_NAME=devopsbysatya.online
HOSTED_ZONE_ID=Z10298813V83SXKO4UHC7


# if mongodb, mysql then instance type should be t3.micro for rest all its t2.micro


for item in $@
do
    if [[ $item == "mongodb" || $item == "mysql" ]]
    then
        INSTANCE_TYPE="t3.micro"
    else
        INSTANCE_TYPE="t2.micro"
    fi
    echo "creating $item instance...."
    IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$item}]" | jq -r '.Instances[0].PrivateIpAddress')

    if [ $? -ne 0 ]
    then
        echo "Instance $item creation failed"
        exit 1
    else
        echo "instance $item creation was succesful. IP Address : $IP_ADDRESS"
    fi

    #Creating route53 records

    aws route53 change-resource-record-sets --hosted-zone-id HOSTED_ZONE_ID --change-batch '
    {
                "Comment": "CREATE/DELETE/UPSERT a record ",
                "Changes": [{
                "Action": "CREATE",
                            "ResourceRecordSet": {
                                        "Name": "'$item.$DOMAIN_NAME'",
                                        "Type": "A",
                                        "TTL": 1,
                                    "ResourceRecords": [{ "Value": "'$IP_ADDRESS'"}]
    }}]
    }
    '
done