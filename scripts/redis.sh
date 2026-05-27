#!/bin/bash
set -e

echo "===== Installing Redis 7 ====="
dnf module disable redis -y
dnf module enable redis:7 -y
dnf install redis -y

echo "===== Configuring Redis ====="
sed -i 's/^bind 127.0.0.1 -::1/bind 0.0.0.0/' /etc/redis/redis.conf
sed -i 's/^protected-mode yes/protected-mode no/' /etc/redis/redis.conf

echo "===== Starting Redis ====="
systemctl enable redis
systemctl start redis
systemctl restart redis

echo "===== Redis status ====="
systemctl status redis --no-pager

echo "===== Redis setup completed ====="