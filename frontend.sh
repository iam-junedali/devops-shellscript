#Red -31, Green - 32, Yellow -33, Blue -34, Magenta -35 and Cyan - 36

#echo -e "\e[31m This is message prints in Red \e[0m"
#echo -e "\e[32m This is message prints in Green \e[0m"
#echo -e "\e[33m This is message prints in Yellow \e[0m"
#echo -e "\e[34m This is message prints in Blue \e[0m"
#echo -e "\e[35m This is message prints in Magenta \e[0m"
#echo -e "\e[36m This is message prints in Cyan \e[0m"

echo -e "\e[36m Install Nginx \e[0m"
yum install nginx -y &>>/tmp/roboshop.log

echo -e "\e[36m Start & Enable Nginx service \e[0m"
systemctl enable nginx &>>/tmp/roboshop.log
systemctl start nginx &>>/tmp/roboshop.log

echo -e "\e[36m Remove the default content that web server is serving \e[0m"
rm -rf /usr/share/nginx/html/* &>>/tmp/roboshop.log

echo -e "\e[36m Download the frontend content \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>/tmp/roboshop.log

echo -e "\e[36m Extract the frontend content \e[0m"
cd /usr/share/nginx/html &>>/tmp/roboshop.log
unzip /tmp/frontend.zip &>>/tmp/roboshop.log

echo -e "\e[36m Update Frontend Configuration \e[0m"
cp /home/centos/devops-shellscript/roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[36m Restart Nginx Service to load the changes of the configuration \e[0m"
systemctl restart nginx &>>/tmp/roboshop.log