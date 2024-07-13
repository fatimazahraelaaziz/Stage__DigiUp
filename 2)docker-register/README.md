# Docker registry 



1) in this step, first we are going to create an lxc container in which we will install the nexus docker registry:

```
lxc launch ubuntu:20.04 private-docker-registry
```
2) we access to the private-docker-registry container to install the nexus docker registry:

```
lxc exec private-docker-registry -- sudo /bin/bash
```
 3) we start instlling the nexus docker registry

in this step we need these Prerequisites:
- Open JDK 8
- Minimum CPU’s: 4
- Ubuntu Server with User sudo privileges.
- Set User limits
- Web Browser
- Firewall/Inbound port: 22, 8081

>you can go through Nexus artifactory official page to know more about system requirement for Nexus.

*update the system packages and Install OpenJDK 1.8 


```
sudo apt-get update
sudo apt install -y openjdk-8-jre-headless
```
* Download Nexus Repository Manager

Navigate to /opt directory

```
cd /opt
```
Download the SonaType Nexus on Ubuntu using wget

```
sudo wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz
```
* Install Nexus Repository 

Extract the Nexus repository setup in /opt directory

```
tar -zxvf latest-unix.tar.gz
```
Rename the extracted Nexus setup folder to nexus

```
sudo mv /opt/nexus-3.30.1-01 /opt/nexus
```
>As security practice, not to run nexus service using root user, so lets create new user named nexus to run nexus service

```
sudo adduser nexus
```
To set no password for nexus user open the visudo file in ubuntu

```
sudo visudo
```
Add below line into it , save and exit
```
nexus ALL=(ALL) NOPASSWD: ALL
```
Give permission to nexus files and nexus directory to nexus user

```
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype-work
```
To run nexus as service at boot time, open /opt/nexus/bin/nexus.rc file, uncomment it and add nexus user as shown below
```
sudo nano /opt/nexus/bin/nexus.rc
```
```
run_as_user="nexus"
```
* Run Nexus as a service using Systemd

To run nexus as service using Systemd
```
sudo nano /etc/systemd/system/nexus.service
```
paste the below lines into it.
```
[Unit]
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
WantedBy=multi-user.target
```

To start nexus service using systemctl

```
sudo systemctl start nexus
```
To enable nexus service at system startup

```
sudo systemctl enable nexus
```
To check nexus service status

```
sudo systemctl status nexus
```
if the nexus service is not started, you can the nexus logs using below command

```
tail -f /opt/sonatype-work/nexus3/log/nexus.log
```

* Access Nexus Repository Web Interface

To access Nexus repository web interface , open your favorite browser

if you are running UFW firewall on Ubuntu, open the firewall port 8081 using below command

```
ufw allow 8081/tcp
```
```
http://server_IP:8081
```
you will see below default nexus page

![WhatsApp Image 2022-08-13 at 21 41 48](https://user-images.githubusercontent.com/78829346/184510121-7a579bec-cd36-4a47-b3df-9ac9e416859a.jpeg)

To login to Nexus, click on Sign In, default username is admin

To find default password run the below command

```
cat /opt/sonatype-work/nexus3/admin.password
```
then you can Change the default nexus admin password and configure Anonymous Access by enabling Anonymous Access.

<img width="309" alt="2" src="https://user-images.githubusercontent.com/78829346/184510195-5abf5c8c-0ef5-48ce-b071-9388fb363979.png">

then click on Finish.

after that we click on server administration and configuration:

![WhatsApp Image 2022-08-13 at 21 46 16](https://user-images.githubusercontent.com/78829346/184510259-f52e16d8-2602-4af5-92f8-be5354071266.jpeg)

we click on repositories

![WhatsApp Image 2022-08-13 at 21 48 28](https://user-images.githubusercontent.com/78829346/184510285-dff2b1ca-e44c-46f8-a3a8-a06dba5d0525.jpeg)

we click on create  repository 

![WhatsApp Image 2022-08-13 at 21 50 02](https://user-images.githubusercontent.com/78829346/184510331-c0eb4031-74e1-4366-8c40-67242beaae1f.jpeg)

we click on docker(hosted)

![WhatsApp Image 2022-08-13 at 21 51 35](https://user-images.githubusercontent.com/78829346/184510468-bd763d5d-7885-4236-9c03-85ea0a7082ad.jpeg)

then we click on create repository.

![WhatsApp Image 2022-08-13 at 21 58 27](https://user-images.githubusercontent.com/78829346/184510567-d0d79829-816a-4c67-99bd-fcfaa5b7758b.jpeg)


Now our docker registry is succesfully created .

to access to the docker registry we click on Browse server contents

![WhatsApp Image 2022-08-13 at 21 59 58](https://user-images.githubusercontent.com/78829346/184510614-bee60864-7086-457d-8b87-7202e9000700.jpeg)

we click on browse
 
 ![WhatsApp Image 2022-08-13 at 21 59 58](https://user-images.githubusercontent.com/78829346/184510640-ec958933-cdf3-4dd9-95bf-461e1f4fddbb.jpeg)

we click on the docker registry that we created

![WhatsApp Image 2022-08-13 at 22 01 28](https://user-images.githubusercontent.com/78829346/184510657-018bea2e-679f-4140-acf4-72db18ce02a6.jpeg)

 **_NOTE:_** if it's the first time you create the docker registry this page will be blank
 
 ![WhatsApp Image 2022-08-13 at 22 04 13](https://user-images.githubusercontent.com/78829346/184510739-f19e59f0-296c-4f62-a66a-9dc9840cb7f6.jpeg)
























