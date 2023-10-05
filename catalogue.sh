echo -e "\e[36m Configuring NodeJS repos \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo -e "\e[36m Install NodeJS \e[0m"
dnf install nodejs -y &>>/tmp/roboshop.log

echo -e "\e[36m Add Roboshop User \e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[36m Create application directory \e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app &>>/tmp/roboshop.log

echo -e "\e[36m Download Application content \e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>/tmp/roboshop.log

echo -e "\e[36m Change to app directory \e[0m"
cd /app

echo -e "\e[36m Extract Application content \e[0m"
unzip /tmp/catalogue.zip &>>/tmp/roboshop.log

echo -e "\e[36m change to app directory \e[0m"
cd /app

echo -e "\e[36m Install NodeJS Dependencies \e[0m"
npm install &>>/tmp/roboshop.log

echo -e "\e[36m setup systemd service \e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[36m Daemon reload \e[0m"
systemctl daemon-reload

echo -e "\e[36m Enable and restart catalogue service \e[0m"
systemctl enable catalogue
systemctl restart catalogue

echo -e "\e[36m Copy mongo.repo file \e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m Install mongo-shell \e[0m"
dnf install mongodb-org-shell -y &>>/tmp/roboshop.log

echo -e "\e[36m Configure Host \e[0m"
mongo --host mongodb-dev.joyousgroups.com </app/schema/catalogue.js &>>/tmp/roboshop.log