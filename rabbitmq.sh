echo -e "\e[36m Download Erlang script \e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo -e "\e[36m Configure Yum repos \e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[36m Install RabbitMQ \e[0m"
dnf install rabbitmq-server -y

echo -e "\e[36m Enable and start rabbitmq-server \e[0m"
systemctl enable rabbitmq-server
systemctl start rabbitmq-server

echo -e "\e[36m Add user \e[0m"
rabbitmqctl add_user roboshop roboshop123

echo -e "\e[36m Set permissions \e[0m"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"