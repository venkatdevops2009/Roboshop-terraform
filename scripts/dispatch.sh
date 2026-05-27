#!/bin/bash
set -e

echo "===== Installing Golang ====="
dnf install golang -y

echo "===== Creating application user ====="
id roboshop &>/dev/null || useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop

echo "===== Preparing app directory ====="
mkdir -p /app

echo "===== Downloading dispatch service ====="
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch-v3.zip

echo "===== Extracting application ====="
cd /app
unzip -o /tmp/dispatch.zip

echo "===== Building application ====="
cd /app
go mod init dispatch || true
go get
go build

echo "===== Creating systemd service ====="
cat <<EOF > /etc/systemd/system/dispatch.service
[Unit]
Description=Dispatch Service
After=network.target

[Service]
User=roboshop
WorkingDirectory=/app
Environment=AMQP_HOST=${RABBITMQ_IP}
Environment=AMQP_USER=roboshop
Environment=AMQP_PASS=roboshop123
ExecStart=/app/dispatch
Restart=always
SyslogIdentifier=dispatch

[Install]
WantedBy=multi-user.target
EOF

echo "===== Starting dispatch service ====="
systemctl daemon-reload
systemctl enable dispatch
systemctl start dispatch

echo "===== Status ====="
systemctl status dispatch --no-pager

echo "===== Dispatch setup completed ====="