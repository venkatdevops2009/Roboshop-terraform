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

echo "===== Download cart service ====="
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart-v3.zip

echo "===== Extract app ====="
cd /app
unzip -o /tmp/cart.zip

echo "===== Install dependencies ====="
cd /app
npm install

echo "===== Create systemd service ====="
cat <<EOF > /etc/systemd/system/cart.service
[Unit]
Description=Cart Service
After=network.target

[Service]
User=roboshop
WorkingDirectory=/app
Environment=REDIS_HOST=${REDIS_IP}
Environment=CATALOGUE_HOST=${CATALOGUE_IP}
Environment=CATALOGUE_PORT=8080
ExecStart=/bin/node /app/server.js
Restart=always
SyslogIdentifier=cart

[Install]
WantedBy=multi-user.target
EOF

echo "===== Start cart service ====="
systemctl daemon-reload
systemctl enable cart
systemctl start cart

echo "===== Status ====="
systemctl status cart --no-pager

echo "===== Cart service setup completed ====="