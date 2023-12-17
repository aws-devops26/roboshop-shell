#!/bin/bash
id=$(id -u)
R="\e[31m"
N="\e[0m"
G="\e[32m"
Y="\e[33m"
TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"
echo "script started executed at $TIMESTAMP" &>> $LOGFILE
VALIDATE()
{
 if [ $1 -ne 0 ]
    then
    echo  -e " $R $2.... FAILED $N"
    exit 5
    else
    echo  -e " $G $2.... SUCCESS $N"
 fi
}
if [ $id -ne 0 ]
    then
    echo -e "$R error : please run this with root access $N "
    exit 5
    else
    echo -e " $G u r root user $N"
fi
dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? " disabiling current node js"
dnf module enable nodejs:18 -y &>>$LOGFILE
 VALIDATE $? " enabiling current node js"
 dnf install nodejs -y &>>$LOGFILE
 VALIDATE $? " installing node js"
 id roboshop
if [ $? -ne 0 ]
 then
  useradd roboshop
  VALIDATE $? "roboshop user creation "
  else
  echo -e " roboshop user already exist: $Y skipping $N "
fi

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> $LOGFILE

VALIDATE $? " Configure YUM Repos from the script"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> $LOGFILE

VALIDATE $? " Configure YUM Repos from the rabbitmq"

dnf install rabbitmq-server -y &>> $LOGFILE
VALIDATE $? " installing rabbitmq server"

systemctl enable rabbitmq-server &>> $LOGFILE
VALIDATE $? "enabiling rabbitmq server"

systemctl start rabbitmq-server &>> $LOGFILE
VALIDATE $? " starting rabbitmq server"
rabbitmqctl add_user roboshop roboshop123 &>> $LOGFILE
VALIDATE $? " adding user roboshop"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOGFILE
VALIDATE $? " setting permissions "
