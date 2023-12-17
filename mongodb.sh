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


cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? " copied MONGODB"
dnf install mongodb-org  &>> $LOGFILE

for mongod in $@
do
    dnf install mongodb-org -y
 if [ $? -ne 0 ]
    then
    dnf install mongodb-org -y 
    VALIDATE $? "installation of mongodb "
 else
    echo -e "$Y mongodb  is already installed....$R SKIPPING $N"
 fi
done
 VALIDATE $? "installed MONGODB" 
 systemctl enable mongod &>> $LOGFILE
 VALIDATE $? "Enabiling MONGODB"
 systemctl start mongod &>> $LOGFILE
 VALIDATE $? "starting MONGODB" 
 sed -i ' s/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE
 VALIDATE $? "remote access to mongodb"
 systemctl restart mongod &>> $LOGFILE
 VALIDATE $? "Restarting MONGODB" 