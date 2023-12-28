#!/bin/bash

AMI=ami-03265a0778a880afb #ami-03265a0778a880afb
SG_ID=sg-070a9eb43e6d6e9eb #replace with your SG ID sg-070a9eb43e6d6e9eb
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")

for i in "${INSTANCES[@]}"
do
    if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $INSTANCE_TYPE --security-group-ids sg-070a9eb43e6d6e9eb 

done