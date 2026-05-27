#!/bin/bash
set -e

echo "===== Installing Python packages ====="
dnf install python3 gcc python3-devel -y

echo "===== Creating application user ====="
id roboshop &>/dev/null || useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop

echo "===== Preparing app directory ====="
mkdir -p /app

echo "===== Downloading payment service ====="
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment-v3.zip

echo "===== Extracting application ====="
cd /app
unzip -o /tmp/payment.zip

echo "===== Installing dependencies ====="
cd /app
pip3 install -r requirements.txt

echo "===== Creating systemd service ====="
cat <<EOF > /etc/systemd/system/payment.service
[Unit]
Description=Payment Service
After=network.target

[Service]
User=root
WorkingDirectory=/app
Environment=CART_HOST=${CART_IP}
Environment=CART_PORT=8080
Environment=USER_HOST=${USER_IP}
Environment=USER_PORT=8080
Environment=AMQP_HOST=${RABBITMQ_IP}
Environment=AMQP_USER=roboshop
Environment=AMQP_PASS=roboshop123
ExecStart=/usr/local/bin/uwsgi --ini payment.ini
ExecStop=/bin/kill -9 \$MAINPID
Restart=always
SyslogIdentifier=payment

[Install]
WantedBy=multi-user.target
EOF

echo "===== Starting payment service ====="
systemctl daemon-reload
systemctl enable payment
systemctl start payment

echo "===== Service status ====="
systemctl status payment --no-pager

echo "===== Payment service setup completed ====="