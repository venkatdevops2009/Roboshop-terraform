#!/bin/bash
set -e

echo "===== Installing Node.js 20 ====="
dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs -y

echo "===== Creating application user ====="
id roboshop &>/dev/null || useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop

echo "===== Preparing app directory ====="
mkdir -p /app

echo "===== Downloading catalogue app ====="
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip
cd /app
unzip -o /tmp/catalogue.zip

echo "===== Installing Node dependencies ====="
cd /app
npm install

echo "===== Creating systemd service ====="
cat <<EOF > /etc/systemd/system/catalogue.service
[Unit]
Description=Catalogue Service
After=network.target

[Service]
User=roboshop
WorkingDirectory=/app
Environment=MONGO=true
Environment=MONGO_URL=mongodb://${MONGO_IP}:27017/catalogue
ExecStart=/bin/node /app/server.js
Restart=always
SyslogIdentifier=catalogue

[Install]
WantedBy=multi-user.target
EOF

echo "===== Starting catalogue service ====="
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

echo "===== Creating MongoDB repo ====="
cat <<EOF > /etc/yum.repos.d/mongo.repo
[mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/9/mongodb-org/7.0/x86_64/
enabled=1
gpgcheck=0
EOF

echo "===== Installing Mongo shell ====="
dnf install mongodb-mongosh -y

echo "===== Loading catalogue data ====="
mongosh --host ${MONGO_IP} </app/db/master-data.js

echo "===== Service status ====="
systemctl status catalogue --no-pager

echo "===== Catalogue setup completed ====="