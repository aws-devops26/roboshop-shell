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
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOGFILE
VALIDATE $? "installing remi release"
dnf module enable redis:remi-6.2 -y &>>$LOGFILE
VALIDATE $? " enabiling redis"
dnf install redis -y &>>$LOGFILE
VALIDATE $? " installing erdis"
sed -i 's/127.0.0.1/0.0.0.0/g '  /etc/redis/redis.conf &>>$LOGFILE
VALIDATE $? "allowing remote connections"
systemctl enable redis &>>$LOGFILE
VALIDATE $? "Enabiling redis"
systemctl start redis &>>$LOGFILE
VALIDATE $? "starting redis" 
