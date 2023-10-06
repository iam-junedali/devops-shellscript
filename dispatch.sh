echo -e "\e[36m Install Golang \e[0m"
dnf install golang -y

echo -e "\e[36m Useradd Roboshop \e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[36m Create directory \e[0m"
mkdir /app &>>/tmp/roboshop.log

echo -e "\e[36m Install the code \e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip &>>/tmp/roboshop.log

echo -e "\e[36m Change the directory \e[0m"
cd /app &>>/tmp/roboshop.log

echo -e "\e[36m Unzip the code \e[0m"
unzip /tmp/dispatch.zip &>>/tmp/roboshop.log

echo -e "\e[36m Download Go Dependencies \e[0m"
go mod init dispatch &>>/tmp/roboshop.log
go get &>>/tmp/roboshop.log
go build &>>/tmp/roboshop.log

echo -e "\e[36m Copy Systemd file \e[0m"
cp /home/centos/devops-shellscript/dispatch.service /etc/systemd/system/dispatch.service &>>/tmp/roboshop.log

echo -e "\e[36m Load the service \e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log

echo -e "\e[36m Enable and Restart the service \e[0m"
systemctl enable dispatch &>>/tmp/roboshop.log
systemctl restart dispatch &>>/tmp/roboshop.log