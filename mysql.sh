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
    exit 1
    else
    echo -e " $G u r root user $N"
fi
dnf module disable mysql -y  &>> $LOGFILE
VALIDATE $? " disable mysql current version"
cp /home/centos/roboshop-shell/mysql.repo  /etc/yum.repos.d/mysql.repo  &>> $LOGFILE
VALIDATE $? "copied my sql repo"
dnf install mysql-community-server -y &>> $LOGFILE
VALIDATE $? "installing my sql community server"
systemctl enable mysqld  &>> $LOGFILE
VALIDATE $? "Enabiling mysql"
systemctl start mysqld  &>> $LOGFILE
VALIDATE $? "starting mysql" 
mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE
VALIDATE $? "mysql instalation and root password"
