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
dnf install maven -y
VALIDATE $? " maven installed"
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

 curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> $LOGFILE
 VALIDATE $? " downloading application code"
 
 cd /app
 VALIDATE $? "moving to app directory"

 mvn clean package  &>> $LOGFILE
 VALIDATE $? "installing dependencies"

 mv target/shipping-1.0.jar shipping.jar &>> $LOGFILE
 VALIDATE $? "renaming jar file"

 cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>> $LOGFILE
 VALIDATE $? "copying shipping service file"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? " reloading demon"

systemctl enable shipping &>> $LOGFILE
VALIDATE $? "Enabiling shipping"

systemctl start shipping &>> $LOGFILE
VALIDATE $? "starting shipping"

dnf install mysql -y &>> $LOGFILE
VALIDATE $? "mysql i nstalled "

mysql -h mysql.awssrivalli.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>> $LOGFILE 
VALIDATE $? "loading shipping data"

systemctl restart shipping &>> $LOGFILE
VALIDATE $? " restart shipping"


