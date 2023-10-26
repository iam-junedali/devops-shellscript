source common.sh
component=catalogue

nodejs

echo -e "${colour} Copy mongo.repo file ${nocolour}"
cp /home/centos/devops-shellscript/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "${colour} Install mongo-shell ${nocolour}"
dnf install mongodb-org-shell -y &>>${logfile}

echo -e "${colour} Configure Host ${nocolour}"
mongo --host mongodb-dev.joyousgroups.com <${app_path}/schema/$component.js &>>${logfile}