#!/bin/bash
set -e

echo "===== Installing MySQL ====="
dnf install mysql-server -y

echo "===== Starting MySQL ====="
systemctl enable mysqld
systemctl start mysqld

echo "===== Setting root password ====="
mysql_secure_installation --set-root-pass RoboShop@1

echo "===== MySQL status ====="
systemctl status mysqld --no-pager

echo "===== MySQL installation completed ====="