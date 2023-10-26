colour="\e[35m"
nocolour="\e[0m"
logfile="/tmp/roboshop.log"
app_path="/app"

application_setup(){

  echo -e "${colour} Add Roboshop User ${nocolour}"
  useradd roboshop &>>${logfile}

  echo -e "${colour} Create application directory ${nocolour}"
  rm -rf ${app_path} &>>${logfile}
  mkdir ${app_path} &>>${logfile}

  echo -e "${colour} Download Application content ${nocolour}"
  curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>${logfile}

  echo -e "${colour} Change to app directory ${nocolour}"
  cd ${app_path}

  echo -e "${colour} Extract the application content ${nocolour}"
  unzip /tmp/$component.zip &>>${logfile}
}

systemd_setup() {

    echo -e "${colour} setup systemd service ${nocolour}"
    cp /home/centos/devops-shellscript/$component.service /etc/systemd/system/$component.service

    echo -e "${colour} Daemon reload ${nocolour}"
    systemctl daemon-reload

    echo -e "${colour} Enable and restart catalogue service ${nocolour}"
    systemctl enable $component &>>${logfile}
    systemctl restart $component &>>${logfile}
}

nodejs() {
  echo -e "${colour} Configuring NodeJS repos ${nocolour}"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${logfile}

  echo -e "${colour} Install NodeJS ${nocolour}"
  dnf install nodejs -y &>>${logfile}

  application_setup

  echo -e "${colour} change to app directory ${nocolour}"
  cd ${app_path}

  echo -e "${colour} Install NodeJS Dependencies ${nocolour}"
  npm install &>>${logfile}

  systemd_setup

}

mongodb_schema_setup() {

  echo -e "${colour} Copy mongo.repo file ${nocolour}"
  cp /home/centos/devops-shellscript/mongo.repo /etc/yum.repos.d/mongo.repo

  echo -e "${colour} Install mongo-shell ${nocolour}"
  dnf install mongodb-org-shell -y &>>${logfile}

  echo -e "${colour} Configure Host ${nocolour}"
  mongo --host mongodb-dev.joyousgroups.com <${app_path}/schema/$component.js &>>${logfile}
}

mysql_schema_setup(){

  echo -e "${colour} Install MySQL ${nocolour}"
  dnf install mysql -y &>>${logfile}

  echo -e "${colour} Install Schema ${nocolour}"
  mysql -h mysql-dev.joyousgroups.com -uroot -pRoboShop@1 < ${app_path}/schema/${component}.sql &>>${logfile}
}

maven() {
  
  echo -e "${colour} Install Maven ${nocolour}"
  dnf install maven -y &>>${logfile}
  
  application_setup

  echo -e "${colour} Maven clean ${nocolour}"
  mvn clean package &>>${logfile}
  
  echo -e "${colour} Install Jar file ${nocolour}"
  mv target/${component}-1.0.jar ${component}.jar &>>${logfile}
  
  systemd_setup
  mysql_schema_setup
  
  echo -e "${colour} Restart ${component} ${nocolour}"
  systemctl restart ${component} &>>${logfile}
  
}