#echo -e "\e[31m Hello in Red colour \e[0m"
#echo -e "\e[32m Hello in Green colour \e[0m"
#echo -e "\e[33m Hello in Yellow colour \e[0m"
#echo -e "\e[34m Hello in Blue colour \e[0m"
#echo -e "\e[35m Hello in Magenta colour \e[0m"
#echo -e "\e[36m Hello in Cyan colour \e[0m"

echo -e "\e[35m Copy mongodb.repo file \e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

echo -e "\e[35m Install MongoDB \e[0m"
dnf install mongodb-org -y &>>/tmp/roboshop.log

#update listen address from 127.0.0.1 to 0.0.0.0
echo -e "\e[35m Updated listen address from 127.0.0.1 to 0.0.0.0 \e[0m"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

echo -e "\e[35m Start & Enable MongoDB Service \e[0m"
systemctl enable mongod &>>/tmp/roboshop.log
systemctl restart mongod &>>/tmp/roboshop.log









