#!/bin/bash
id=$(id -u)
R="\e[31m"
N="\e[0m"
G="\e[32m"
Y="\e[33m"
TIMESTAMP= $(date +%F-%H-%M-%S)
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
dnf module enable nodejs:18 -y $LOGFILE
 VALIDATE $? " enabiling current node js"
 dnf install nodejs -y $LOGFILE
 VALIDATE $? " installing node js"
 useradd roboshop $LOGFILE
 VALIDATE $? "creating roboshop user"
 mkdir /app $LOGFILE
 VALIDATE $? "app directory created"
 curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip $LOGFILE
 VALIDATE $? "downloading catalogue application"
 cd /app 
unzip /tmp/catalogue.zip $LOGFILE
VALIDATE $? "unziping catalogue"
npm install $LOGFILE
VALIDATE $? "installing dependencies"
cp /home/centos/roboshop-shell/catalogue.service/etc/systemd/system/catalogue.service $LOGFILE
VALIDATE $? "copying catalogue service file"
systemctl daemon-reload $LOGFILE
VALIDATE $? " reloading demon"
systemctl enable catalogue &>> $LOGFILE
VALIDATE $? "Enabiling catalogue"
systemctl start catalogue &>> $LOGFILE
VALIDATE $? "starting catalogue"  
cp /home/centos/roboshop-shell/mongo.repo/etc/yum.repos.d/mongo.repo $LOGFILE
VALIDATE $? "copying mongodb service file"
dnf install mongodb-org-shell -y $LOGFILE
VALIDATE $? "installing mongodb client"
mongo --host mongodb.awssrivalli.online </app/schema/catalogue.js $LOGFILE
