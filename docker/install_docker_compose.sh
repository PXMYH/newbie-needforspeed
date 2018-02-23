#!/bin/bash

set -x -e

# update repo
sudo yum update -y


# install dependencies
sudo yum install -y netstat git rubygems gcc kernel-devel make perl
sudo yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel maven

# notify yum docker repo
tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

# install docker
sudo yum install -y docker-engine

sudo systemctl start docker
sudo systemctl enable docker

# install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose

echo "docker version: $(docker --version)"
echo "docker compose version: $(docker-compose --version)"
