#!/bin/bash

sudo -i
sudo apt update -y && sudo apt upgrade -y
sudo apt install nginx -y
sudo mkdir -p /var/www/html/api
sudo echo "This is ec2 response from cloudfront" > /var/www/html/api/index.html
sudo echo "Second file from ec2 instance" > /var/www/html/api/index1.html
sudo systemctl enable --now nginx
sudo systemctl restart nginx