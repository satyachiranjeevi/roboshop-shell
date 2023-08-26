#!/bin/bash

#Install web  on Linux ec2 instance

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

#==============================

yum install nginx -y &>> $LOGFILE

VALIDATE $? "install nginx"

systemctl enable nginx &>> $LOGFILE

VALIDATE $? "enable nginx"

systemctl start nginx &>> $LOGFILE

VALIDATE $? "start nginx"

rm -rf /usr/share/nginx/html/* &>> $LOGFILE

VALIDATE $? "delet html files"

curl -o /tmp/web.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>> $LOGFILE

VALIDATE $? "download web.zip"

cd /usr/share/nginx/html &>> $LOGFILE

VALIDATE $? "move to html folder"

unzip /tmp/web.zip &>> $LOGFILE

VALIDATE $? "unzip web.zip"

cp /root/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>> $LOGFILE

VALIDATE $? "cp roboshop.conf"

systemctl restart nginx &>> $LOGFILE

VALIDATE $? "restart nginx"