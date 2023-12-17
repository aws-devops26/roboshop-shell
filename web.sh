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
dnf install nginx -y 
VALIDATE $? " installing nginx"
systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enabiling nginx"
systemctl start nginx &>>$LOGFILE
VALIDATE $? "starting nginx" 
rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "remove default website"
curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$LOGFILE
VALIDATE $? " downloaded web application nginx"
cd /usr/share/nginx/html &>>$LOGFILE
VALIDATE $? " moving nginx html directory"
unzip -o /tmp/web.zip &>>$LOGFILE
VALIDATE $? " unzipping nginx"
cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$LOGFILE
VALIDATE $? " roboshop reverse proxy config"
systemctl restart nginx &>>$LOGFILE
VALIDATE $? " restarting nginx"

