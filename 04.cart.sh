#!/bin/bash

#Install cart service on Linux ec2 instance

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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>> $LOGFILE

VALIDATE $? "setting up node js repos"

yum install nodejs -y &>> $LOGFILE

VALIDATE $? "install nodejs"

#Check if user roboshop already exists
id -u roboshop
if [ $? -ne 0 ]
then
    echo -e "$R user not available. It will be created now. $N"
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "add user roboshop"
else
    echo -e "$Y user already exists $N"
fi

#check if app directory is already available or not and then create accordingly
if [ -d /app ]
then
    echo -e "$Y Directory /app already available. $N"
else
    echo -e "$R Directory /app not available $N"
    mkdir /app &>> $LOGFILE
    VALIDATE $? "create app dir"
fi

#===========================================

curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip &>> $LOGFILE

VALIDATE $? "download cart.zip"

cd /app &>> $LOGFILE

VALIDATE $? "move to app dir"

unzip /tmp/cart.zip &>> $LOGFILE

VALIDATE $? "unzip cart in app folder"

npm install &>> $LOGFILE

VALIDATE $? "install npm packages"

cp /root/roboshop-shell/cart.service /etc/systemd/system/cart.service &>>$LOGFILE

VALIDATE $? "copy cart.service file"

systemctl daemon-reload &>> $LOGFILE

VALIDATE $? "daemon-reload"

systemctl enable cart &>> $LOGFILE

VALIDATE $? "enable cart"

systemctl start catalogue &>> $LOGFILE

VALIDATE $? "start catalogue"