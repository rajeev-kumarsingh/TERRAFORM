#!/bin/bash
yum update -y
yum -y remove httpd
yum -y remove httpd-tools
yum install -y httpd php
service httpd start
chkconfig httpd on

usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;
cd /var/www/html
echo "Hello World" > index.html
curl https://raw.githubusercontent.com/hashicorp/learn-terramino/master/index.php -O
