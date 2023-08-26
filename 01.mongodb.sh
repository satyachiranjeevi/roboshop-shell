#!/bin/bash

#Install mongo db on Linux ec2 instance

USERID=$(id -u)

SCRIPT_NAME=$0
DATE=$(date +%F)
LOGFILE=/tmp/$SCRIPT_NAME-$DATE.log

R="\e[31m" #Red color
G="\e[32m" #Green color
N="\e[0m"  #Normal color
Y="\e[33m" #Yellow color


#1. Check if User is root user or not. If not, show error message and exit from the script
if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR: Only root user can perform this activity. $N Kindly login as Root User and continue."
    exit 1
fi

#Validate function : it will check if the command execution is successfull or not. If failed, it will exit

VALIDATE()
{
    if [ $1 -ne 0 ]
    then
        echo -e "$R ERROR: Command $2 execution has got failed $N"
        exit 1
    else
        echo -e "$G Success: COmmand $2 execution has been successfully completed. $N"
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "copied mongodb repo into yum.repos.d"

yum install mongodb-org -y &>> $LOGFILE

VALIDATE $? "Installing mongodb-org package"

systemctl enable mongod &>> $LOGFILE

VALIDATE $? "enable mongodb"

systemctl start mongod &>> $LOGFILE

VALIDATE $? "start mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE

VALIDATE $? "Updated IP Address in mongod.conf file"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "restart mongodb"