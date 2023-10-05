echo -e "\e[36m Install Maven \e[0m"
dnf install maven -y &>>/tmp/roboshop.log

echo -e "\e[36m Add user Roboshop \e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[36m create app \e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app &>>/tmp/roboshop.log

echo -e "\e[36m Install code \e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip &>>/tmp/roboshop.log

echo -e "\e[36m change to app directory \e[0m"
cd /app &>>/tmp/roboshop.log

echo -e "\e[36m Unzip the code \e[0m"
unzip /tmp/shipping.zip &>>/tmp/roboshop.log

echo -e "\e[36m Maven clean \e[0m"
mvn clean package &>>/tmp/roboshop.log

echo -e "\e[36m Install Jar file \e[0m"
mv target/shipping-1.0.jar shipping.jar &>>/tmp/roboshop.log

echo -e "\e[36m Copy Systemd Shipping file \e[0m"
cp /home/centos/devops-shellscript/shipping.service /etc/systemd/system/shipping.service &>>/tmp/roboshop.log

echo -e "\e[36m daemon reload \e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log

echo -e "\e[36m Enable and start shipping \e[0m"
systemctl enable shipping &>>/tmp/roboshop.log
systemctl start shipping &>>/tmp/roboshop.log

echo -e "\e[36m Install MySQL \e[0m"
dnf install mysql -y &>>/tmp/roboshop.log

echo -e "\e[36m Install Schema \e[0m"
mysql -h mysql-dev.joyousgroups.com -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>/tmp/roboshop.log

echo -e "\e[36m Restart Shipping \e[0m"
systemctl restart shipping &>>/tmp/roboshop.log