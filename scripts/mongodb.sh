#!/bin/bash
set -e

echo "===== Creating MongoDB repo ====="
cat <<EOF > /etc/yum.repos.d/mongo.repo
[mongodb-org-7.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/9/mongodb-org/7.0/x86_64/
enabled=1
gpgcheck=0
EOF

echo "===== Installing MongoDB ====="
dnf install mongodb-org -y

echo "===== Configuring MongoDB ====="
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf

echo "===== Starting MongoDB ====="
systemctl enable mongod
systemctl start mongod
systemctl restart mongod

echo "===== MongoDB Status ====="
systemctl status mongod --no-pager

echo "===== MongoDB Installation Completed ====="