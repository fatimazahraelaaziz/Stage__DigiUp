#!/bin/bash

# This script has been tested on Ubuntu 20.04

echo "[TASK 0] Install OpenJDK" 
apt-get update >/dev/null 2>&1
apt install openjdk-8-jre-headless >/dev/null 2>&1

echo "[TASK 1] Install Nexus Repository" 
cd /opt
wget https://download.sonatype.com/nexus/3/nexus-3.41.0-01-unix.tar.gz
tar -zxvf latest-unix.tar.gz
mv /opt/nexus-3.41.0-01 /opt/nexus
adduser nexus
visudo
echo "nexus ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.tmp
chown -R nexus:nexus /opt/nexus 
chown -R nexus:nexus /opt/sonatype-work
echo "run_as_user='nexus'" > /opt/nexus/bin/nexus.rc
echo ' [Unit]
Description=nexus service
After=network.target
[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
User=nexus
Restart=on-abort
[Install]
WantedBy=multi-user.target'




