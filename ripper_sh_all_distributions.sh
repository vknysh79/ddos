#!/bin/bash
# variables
disbalance_folder="/tmp/disbalance"
disbalance_source="https://github.com/disbalancer-project/main/raw/main/launcher-disbalancer-docker-x64.zip"

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
if [ `which yum` ]; then
    yum update -y && sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo -y
    yum install yum-utils device-mapper-persistent-data lvm2 wget zip docker-ce screen docker-ce-cli containerd.io -y
    systemctl start docker.service
        mkdir $disbalance_folder && cd $disbalance_folder
        wget --retry-connrefused  --read-timeout=20 --timeout=15 --tries=0 --continue $disbalance_source
        unzip launcher-disbalancer-docker-x64.zip
        cd launcher-disbalancer-docker-x64
            docker build -t disbalancer .
            screen -S liberator -dm docker run --restart unless-stopped disbalancer
        echo "Done!"
elif [ `which apt` ]; then
    apt update  
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        apt upgrade -y && apt install -y wget zip docker-ce screen docker-ce-cli containerd.io
        mkdir $disbalance_folder && cd $disbalance_folder
        wget --retry-connrefused  --read-timeout=20 --timeout=15 --tries=0 --continue $disbalance_source
        unzip launcher-disbalancer-docker-x64.zip
        cd launcher-disbalancer-docker-x64
            docker build -t disbalancer .
            screen -S liberator -dm docker run --restart unless-stopped disbalancer
        echo "Done!"
elif [ `which apk` ]; then
    echo "http://dl-cdn.alpinelinux.org/alpine/latest-stable/community" >> /etc/apk/repositories
    apk update && apk add docker wget screen zip && rc-update add docker boot && service docker start
        mkdir $disbalance_folder && cd $disbalance_folder
        wget --retry-connrefused  --read-timeout=20 --timeout=15 --tries=0 --continue $disbalance_source
        unzip launcher-disbalancer-docker-x64.zip
        cd launcher-disbalancer-docker-x64
            docker build -t disbalancer .
            screen -S liberator -dm docker run --restart unless-stopped disbalancer
        echo "Done!"
else
   IS_UNKNOWN=1
fi

