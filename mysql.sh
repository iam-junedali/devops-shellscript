echo -e "\e[36m Disable MySQL \e[0m"
dnf module disable mysql -y &>>/tmp/roboshop.log

echo -e "\e[36m Copy mysql.repo file \e[0m"
cp /home/centos/devops-shellscript/mysql.repo /etc/yum.repos.d/mysql.repo &>>/tmp/roboshop.log

echo -e "\e[36m Install MySQL Server \e[0m"
dnf install mysql-community-server -y &>>/tmp/roboshop.log

echo -e "\e[36m Enable and Restart the Server \e[0m"
systemctl enable mysqld &>>/tmp/roboshop.log
systemctl restart mysqld &>>/tmp/roboshop.log

echo -e "\e[36m Set Root Password \e[0m"
mysql_secure_installation --set-root-pass RoboShop@1 &>>/tmp/roboshop.log