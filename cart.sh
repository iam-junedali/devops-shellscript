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
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip &>>/tmp/roboshop.log

echo -e "\e[36m Change to app directory \e[0m"
cd /app

echo -e "\e[36m Extract Application content \e[0m"
unzip /tmp/cart.zip &>>/tmp/roboshop.log

echo -e "\e[36m change to app directory \e[0m"
cd /app

echo -e "\e[36m Install NodeJS Dependencies \e[0m"
npm install &>>/tmp/roboshop.log

echo -e "\e[36m setup systemd service \e[0m"
cp /home/centos/devops-shellscript/cart.service /etc/systemd/system/cart.service

echo -e "\e[36m Daemon reload \e[0m"
systemctl daemon-reload

echo -e "\e[36m Enable and restart cart service \e[0m"
systemctl enable cart &>>/tmp/roboshop.log
systemctl restart cart &>>/tmp/roboshop.log