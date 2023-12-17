!/bin/bash
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
 mkdir -p /app 
 VALIDATE $? "app directory created"
 curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip
 VALIDATE $? "downloading cart  application"
 cd /app 
unzip -o /tmp/cart.zip  &>>$LOGFILE
VALIDATE $? "unziping cart"
npm install &>>$LOGFILE
VALIDATE $? "installing dependencies"
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service &>>$LOGFILE
VALIDATE $? "copying cart service file"
systemctl daemon-reload &>>$LOGFILE
VALIDATE $? " reloading demon"
systemctl enable cart &>>$LOGFILE
VALIDATE $? "Enabiling cart"
systemctl start cart &>>$LOGFILE
VALIDATE $? "starting cart" 
