colour="\e[35m"
nocolour="\e[0m"
logfile="/tmp/roboshop.log"
app_path="/app"

application_setup(){

  echo -e "${colour} Add Roboshop User ${nocolour}"
  useradd roboshop &>>${logfile}
  echo $?

  echo -e "${colour} Create application directory ${nocolour}"
  rm -rf ${app_path} &>>${logfile}
  mkdir ${app_path} &>>${logfile}
  echo $?

  echo -e "${colour} Download Application content ${nocolour}"
  curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>${logfile}
  echo $?

  echo -e "${colour} Change to app directory ${nocolour}"
  cd ${app_path}
  echo $?

  echo -e "${colour} Extract the application content ${nocolour}"
  unzip /tmp/$component.zip &>>${logfile}
  echo $?
}

systemd_setup() {

    echo -e "${colour} setup systemd service ${nocolour}"
    cp /home/centos/devops-shellscript/$component.service /etc/systemd/system/$component.service
    echo $?

    echo -e "${colour} Daemon reload ${nocolour}"
    systemctl daemon-reload
    echo $?

    echo -e "${colour} Enable and restart catalogue service ${nocolour}"
    systemctl enable $component &>>${logfile}
    systemctl restart $component &>>${logfile}
    echo $?
}

nodejs() {
  echo -e "${colour} Configuring NodeJS repos ${nocolour}"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${logfile}
  echo $?

  echo -e "${colour} Install NodeJS ${nocolour}"
  dnf install nodejs -y &>>${logfile}
  echo $?

  application_setup

  echo -e "${colour} change to app directory ${nocolour}"
  cd ${app_path}
  echo $?

  echo -e "${colour} Install NodeJS Dependencies ${nocolour}"
  npm install &>>${logfile}
  echo $?

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
  echo $?

  echo -e "${colour} Install Schema ${nocolour}"
  mysql -h mysql-dev.joyousgroups.com -uroot -pRoboShop@1 < ${app_path}/schema/${component}.sql &>>${logfile}
  echo $?
}

maven() {
  
  echo -e "${colour} Install Maven ${nocolour}"
  dnf install maven -y &>>${logfile}
  echo $?
  
  application_setup

  echo -e "${colour} Maven clean ${nocolour}"
  mvn clean package &>>${logfile}
  echo $?
  
  echo -e "${colour} Install Jar file ${nocolour}"
  mv target/${component}-1.0.jar ${component}.jar &>>${logfile}
  echo $?
  
  systemd_setup
  mysql_schema_setup
  
  echo -e "${colour} Restart ${component} ${nocolour}"
  systemctl restart ${component} &>>${logfile}
  echo $?
}

python() {

  echo -e "${colour} Install python ${nocolour}"
  dnf install python36 gcc python3-devel -y &>>${logfile}
  echo $?

  application_setup

  echo -e "${colour} Download the dependencies ${nocolour}"
  pip3.6 install -r requirements.txt &>>${logfile}
  echo $?

  systemd_setup
}

go_lang() {

  echo -e "${colour} Install Golang ${nocolour}"
  dnf install golang -y &>>${logfile}
  echo $?

  application_setup

  echo -e "${colour} Download Go Dependencies ${nocolour}"
  go mod init dispatch &>>${logfile}
  go get &>>${logfile}
  go build &>>${logfile}
  echo $?

  systemd_setup
}