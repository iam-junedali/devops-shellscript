source common.sh
component=cart

echo -e "${colour} Configuring NodeJS repos ${nocolour}"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${logfile}

echo -e "${colour} Install NodeJS ${nocolour}"
dnf install nodejs -y &>>${logfile}

echo -e "${colour} Add Roboshop User ${nocolour}"
useradd roboshop &>>${logfile}

echo -e "${colour} Create application directory ${nocolour}"
rm -rf ${app_path} &>>${logfile}
mkdir ${app_path} &>>${logfile}

echo -e "${colour} Download Application content ${nocolour}"
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${logfile}

echo -e "${colour} Change to app directory ${nocolour}"
cd ${app_path}

echo -e "${colour} Extract Application content ${nocolour}"
unzip /tmp/${component}.zip &>>${logfile}

echo -e "${colour} change to app directory ${nocolour}"
cd ${app_path}

echo -e "${colour} Install NodeJS Dependencies ${nocolour}"
npm install &>>${logfile}

echo -e "${colour} setup systemd service ${nocolour}"
cp /home/centos/devops-shellscript/${component}.service /etc/systemd/system/${component}.service

echo -e "${colour} Daemon reload ${nocolour}"
systemctl daemon-reload

echo -e "${colour} Enable and restart ${component} service ${nocolour}"
systemctl enable ${component} &>>${logfile}
systemctl restart ${component} &>>${logfile}