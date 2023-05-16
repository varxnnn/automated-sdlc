#!/bin/bash
sudo yum -y install docker
sudo usermod -a -G docker ec2-user
sudo systemctl start docker
docker pull varxn/major-react:0.2
docker run -d --name react --restart unless-stopped -p 80:80 varxn/major-react:0.2