#!/bin/bash
set -e

echo "===== Installing packages ====="

dnf install nginx -y

echo "===== Enable and start nginx ====="

systemctl enable nginx
systemctl start nginx

echo "===== Cleaning old frontend files ====="

rm -rf /usr/share/nginx/html/*

echo "===== Downloading frontend code ====="

curl -L -o /tmp/frontend.zip \
https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip

echo "===== Extracting frontend ====="

cd /usr/share/nginx/html

unzip -o /tmp/frontend.zip

echo "===== Configuring nginx ====="

cat <<EOF > /etc/nginx/default.d/roboshop.conf

proxy_http_version 1.1;

location /images/ {
    expires 5s;
    root /usr/share/nginx/html;
    try_files \$uri /images/placeholder.jpg;
}

location /api/catalogue/ {
    proxy_pass http://${CATALOGUE_IP}:8080/;
}

location /api/user/ {
    proxy_pass http://${USER_IP}:8080/;
}

location /api/cart/ {
    proxy_pass http://${CART_IP}:8080/;
}

location /api/shipping/ {
    proxy_pass http://${SHIPPING_IP}:8080/;
}

location /api/payment/ {
    proxy_pass http://${PAYMENT_IP}:8080/;
}

location /health {
    stub_status on;
    access_log off;
}

EOF

echo "===== Testing nginx config ====="

nginx -t

echo "===== Restarting nginx ====="

systemctl restart nginx

echo "===== Frontend deployment completed ====="

systemctl status nginx --no-pager