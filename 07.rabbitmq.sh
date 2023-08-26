#!/bin/bash

#Install rabbitmq on Linux ec2 instance

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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOGFILE

VALIDATE $? "download scripts/packages provided by vendor"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOGFILE

VALIDATE $? "download scripts/packages provided by RBQ"

yum install rabbitmq-server -y &>> $LOGFILE

VALIDATE $? "install rabbitmq"

systemctl enable rabbitmq-server &>> $LOGFILE

VALIDATE $? "enable rabbitmq-"

systemctl start rabbitmq-server &>> $LOGFILE

VALIDATE $? "start rabbitmq"

rabbitmqctl add_user roboshop roboshop123 &>> $LOGFILE

VALIDATE $? "add user roboshop"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGFILE

VALIDATE $? "set parmissions"