# reverse proxy 

in this step we are going to set up nginx reverse proxy manager that comes as a pre-built docker image that enables you to easily forward to your websites running at home or otherwise, including free SSL, without having to know too much about Nginx or Letsencrypt.


![nginx-proxy-manager](https://user-images.githubusercontent.com/78829346/184511449-cdc877bc-0f43-450d-b3bb-247bc32ac1a5.png)


First, we will launch the lxc container where we will set up the nginx reverse proxy manager.

```
lxc launch ubuntu:20.04 ngpm
```
we access to the container

```
lxc exec ngpm -- sudo /bin/bash
```
now we can start installing the nginx reverse proxy manager.

### Step 1 - Configure Firewall

Check if the firewall is running.

```
sudo ufw status
```
If it is running, then open ports 80, 81 and 443.

```
sudo ufw allow 80
sudo ufw allow 81
sudo ufw allow 443
```
### Step 2 - Install Docker

#### Uninstall old versions

```
 apt-get remove docker docker-engine docker.io containerd runc
```


##### Set up the repository

  1- Update the apt package index and install packages to allow apt to use a repository over HTTPS:
```
sudo apt-get update

sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```
2- Add Docker’s official GPG key:

```
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```
3- Use the following command to set up the repository:

```
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
#### Install Docker Engine
```
apt-get update 
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

Enable and Start the Docker service.

```
sudo systemctl start docker --now
```
### Step 3 - Install Docker Compose

Download and install Docker compose binary.

```
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```
Apply executable permission to the binary.

```
sudo chmod +x /usr/local/bin/docker-compose
```
### Step 4 - Create Docker Compose File

Create a docker-compose.yml file similar to this:

```
version: '3'
services:
  app:
    image: 'jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    ports:
      - '80:80'
      - '81:81'
      - '443:443'
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
```

before Bring up your stack by running you need to enable nested conteneurisation,
outside the conatainer run this command, you can change "ngpm" by the name of your container

```
lxc config set ngpm security.nesting true
```
access again to the lxc container and run this command:
```
docker-compose up -d

```
Log in to the Admin UI

```
http://@your-@IP:81
```

Default Admin User:

```
Email:    admin@example.com
Password: changeme
```

you can change now the email and the password.

then you find the home page of nginx proxy manager

![WhatsApp Image 2022-08-13 at 22 49 42](https://user-images.githubusercontent.com/78829346/184511854-0a9c8726-6d4b-43b2-8aea-c32639f01290.jpeg)

to create new hosts click on proxy hosts

![WhatsApp Image 2022-08-13 at 22 48 16](https://user-images.githubusercontent.com/78829346/184511829-a2c805e8-98e4-4abd-87bc-b620b444140a.jpeg)

click on add proxy host
![WhatsApp Image 2022-08-13 at 22 51 59](https://user-images.githubusercontent.com/78829346/184511893-7fb42c32-5d28-471e-8f85-d3d52be7831e.jpeg)

 you can add a host proxy for example for the nexus repository as the following:
 
 ![WhatsApp Image 2022-08-13 at 22 55 01](https://user-images.githubusercontent.com/78829346/184511958-39a12ef8-d23b-4320-b335-97c34b02306a.jpeg)

now if we type http://nexus in the browser we have to be forwarded to the nexus repository.

























