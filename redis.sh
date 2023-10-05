echo -e "\e[36m Install Redis Repos \e[0m"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>/tmp/roboshop.log

echo -e "\e[36m Enable Redis 6 version \e[0m"
dnf module enable redis:remi-6.2 -y &>>/tmp/roboshop.log

echo -e "\e[36m Install Redis \e[0m"
dnf install redis -y &>>/tmp/roboshop.log

echo -e "\e[36m Install Redis Repos \e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>/tmp/roboshop.log

echo -e "\e[36m Enable Redis\e[0m"
systemctl enable redis &>>/tmp/roboshop.log

echo -e "\e[36m Start Redis \e[0m"
systemctl restart redis &>>/tmp/roboshop.log