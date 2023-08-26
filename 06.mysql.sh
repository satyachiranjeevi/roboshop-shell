#!/bin/bash

#Install mysql on Linux ec2 instance

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

yum module disable mysql -y &>> $LOGFILE

VALIDATE $? "disable mysql"

cp /root/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGFILE

VALIDATE $? "Copying MySQL repo" 

yum install mysql-community-server -y &>> $LOGFILE

VALIDATE $? "install mysql"

systemctl enable mysqld &>> $LOGFILE

VALIDATE $? "enable mysql"

systemctl start mysqld &>> $LOGFILE

VALIDATE $? "start mysqld"
 
mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE

VALIDATE $? "set root password"
