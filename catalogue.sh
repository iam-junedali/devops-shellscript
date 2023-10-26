component=catalogue
colour="\e[36m"
nocolour="\e[0m"

echo -e "${colour} Configuring NodeJS repos ${nocolour}"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo -e "${colour} Install NodeJS ${nocolour}"
dnf install nodejs -y &>>/tmp/roboshop.log

echo -e "${colour} Add Roboshop User ${nocolour}"
useradd roboshop &>>/tmp/roboshop.log

echo -e "${colour} Create application directory ${nocolour}"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app &>>/tmp/roboshop.log

echo -e "${colour} Download Application content ${nocolour}"
curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>/tmp/roboshop.log

echo -e "${colour} Change to app directory ${nocolour}"
cd /app

echo -e "${colour} Extract Application content ${nocolour}"
unzip /tmp/$component.zip &>>/tmp/roboshop.log

echo -e "${colour} change to app directory ${nocolour}"
cd /app

echo -e "${colour} Install NodeJS Dependencies ${nocolour}"
npm install &>>/tmp/roboshop.log

echo -e "${colour} setup systemd service ${nocolour}"
cp /home/centos/devops-shellscript/$component.service /etc/systemd/system/$component.service

echo -e "${colour} Daemon reload ${nocolour}"
systemctl daemon-reload

echo -e "${colour} Enable and restart catalogue service ${nocolour}"
systemctl enable $component &>>/tmp/roboshop.log
systemctl restart $component &>>/tmp/roboshop.log

echo -e "${colour} Copy mongo.repo file ${nocolour}"
cp /home/centos/devops-shellscript/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "${colour} Install mongo-shell ${nocolour}"
dnf install mongodb-org-shell -y &>>/tmp/roboshop.log

echo -e "${colour} Configure Host ${nocolour}"
mongo --host mongodb-dev.joyousgroups.com </app/schema/$component.js &>>/tmp/roboshop.log