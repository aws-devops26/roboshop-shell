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

dnf install python36 gcc python3-devel -y

id roboshop
if [ $? -ne 0 ]
 then
  useradd roboshop
  VALIDATE $? "roboshop user creation "
  else
  echo -e " roboshop user already exist: $Y skipping $N "
fi
 mkdir -p /app 
 VALIDATE $? "app directory created"

 curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> $LOGFILE
 VALIDATE $? "downloading payment"

 cd /app 

unzip -o /tmp/payment.zip  &>> $LOGFILE
VALIDATE $? "unziping payment"

cd /app

pip3.6 install -r requirements.txt &>> $LOGFILE
VALIDATE $? "installing dependencies"

cp  /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service &>> $LOGFILE
VALIDATE $? " copy payment services"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? " reloading demon"

systemctl enable payment &>> $LOGFILE
VALIDATE $? "Enabiling payment"

systemctl start payment &>> $LOGFILE
VALIDATE $? "starting payment"
