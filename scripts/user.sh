#!/bin/bash
set -e

echo "===== Install NodeJS ====="
dnf module disable nodejs -y
dnf module enable nodejs:20 -y
dnf install nodejs unzip -y

echo "===== Create app user ====="
id roboshop &>/dev/null || useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop

echo "===== Create app directory ====="
mkdir -p /app

echo "===== Download user service ====="
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user-v3.zip

echo "===== Extract app ====="
cd /app
unzip -o /tmp/user.zip

echo "===== Install dependencies ====="
cd /app
npm install

echo "===== Create systemd service ====="
cat <<EOF > /etc/systemd/system/user.service
[Unit]
Description=User Service
After=network.target

[Service]
User=roboshop
WorkingDirectory=/app
Environment=MONGO=true
Environment=REDIS_URL=redis://${REDIS_IP}:6379
Environment=MONGO_URL=mongodb://${MONGO_IP}:27017/users
ExecStart=/bin/node /app/server.js
Restart=always
SyslogIdentifier=user

[Install]
WantedBy=multi-user.target
EOF

echo "===== Start service ====="
systemctl daemon-reload
systemctl enable user
systemctl start user

echo "===== Status ====="
systemctl status user --no-pager

echo "===== User service setup completed ====="