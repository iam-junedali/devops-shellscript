'\033[Install Nginx\033[0m'
dnf install nginx -y

systemctl enable nginx
systemctl start nginx