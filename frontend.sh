#Red -31, Green - 32, Yellow -33, Blue -34, Megenta -35 and Cyan - 36

echo -e "\e[31m This is message \e[0m"
echo -e "\e[32m This is message \e[0m"
echo -e "\e[33m This is message \e[0m"
echo -e "\e[34m This is message \e[0m"
echo -e "\e[35m This is message \e[0m"
echo -e "\e[36m This is message \e[0m"

echo -e "\e[36m Install Nginx \e[0m"
yum install nginx -y

echo -e "\e[36m Start & Enable Nginx service \e[0m"
systemctl enable nginx
systemctl start nginx

echo -e "\e[36m Remove the default content that web server is serving \e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[36m Download the frontend content \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[36m Extract the frontend content \e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

#Copy the roboshop.conf file

echo -e "\e[36m Restart Nginx Service to load the changes of the configuration \e[0m"
systemctl restart nginx



