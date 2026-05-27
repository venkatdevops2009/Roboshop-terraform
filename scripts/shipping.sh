#!/bin/bash
set -e

echo "===== Installing Java + Maven + MySQL client ====="
dnf install maven mysql -y

echo "===== Creating application user ====="
id roboshop &>/dev/null || useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop

echo "===== Preparing app directory ====="
mkdir -p /app

echo "===== Downloading shipping service ====="
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip

echo "===== Extracting app ====="
cd /app
unzip -o /tmp/shipping.zip

echo "===== Building application ====="
cd /app
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo "===== Creating systemd service ====="
cat <<EOF > /etc/systemd/system/shipping.service
[Unit]
Description=Shipping Service
After=network.target

[Service]
User=roboshop
WorkingDirectory=/app
Environment=CART_ENDPOINT=${CART_IP}:8080
Environment=DB_HOST=${MYSQL_IP}
ExecStart=/bin/java -jar /app/shipping.jar
Restart=always
SyslogIdentifier=shipping

[Install]
WantedBy=multi-user.target
EOF

echo "===== Loading database schema ====="
mysql -h ${MYSQL_IP} -uroot -pRoboShop@1 < /app/db/schema.sql
mysql -h ${MYSQL_IP} -uroot -pRoboShop@1 < /app/db/app-user.sql
mysql -h ${MYSQL_IP} -uroot -pRoboShop@1 < /app/db/master-data.sql

echo "===== Starting shipping service ====="
systemctl daemon-reload
systemctl enable shipping
systemctl start shipping
systemctl restart shipping

echo "===== Status ====="
systemctl status shipping --no-pager

echo "===== Shipping service setup completed ====="