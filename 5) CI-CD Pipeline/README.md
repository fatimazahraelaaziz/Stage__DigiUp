# CI-CD Pipeline

in this phase we will see  how to automate Docker builds using Jenkins and to deploy a springboot application to a kubernetes cluster.

![Untitled](https://user-images.githubusercontent.com/78829346/184555422-804aba9f-9892-4268-ba6c-2134f3e3ace7.png)

now that we have  , nexus docker registry  installed and running we have to configure the host machine on the Vm that we are working on so that we can push images to nexus docker registry which is installed in a lxc container. for that we need to Configure Docker service to use insecure registry with http.
so we start by installing docker 

## install docker 

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
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

Enable and Start the Docker service.

```
sudo systemctl start docker --now
```
## Steps to configure in Docker to upload Docker images to Nexus:

Create Docker daemon file if it does not exist.

```
sudo vi /etc/docker/daemon.json
```
Add entries like below:
Enter NExus URL along with port number used for Docker registery.


![WhatsApp Image 2022-08-14 at 13 40 32](https://user-images.githubusercontent.com/78829346/184537307-39944064-1245-4d7c-8374-8c8ae3cfb23b.jpeg)


```
{
    "insecure-registries" : ["nexus_public_dns_name:port number used for Docker registery"]
}
```
Restart Docker daemon after above configuration changes.

```
sudo systemctl restart docker
```

Make sure Docker was able to restart successfully.

![WhatsApp Image 2022-08-14 at 13 38 37](https://user-images.githubusercontent.com/78829346/184537263-21c165bd-67cc-47d1-b0e1-2651052d0c15.jpeg)


## install jenkins 
in the host machine we install jenkins 

```
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
```

### Installation of Java

```
sudo apt update
sudo apt install openjdk-11-jre
```
to see if java is succesfully installed run this command:

```
java -version
```

the output should be like the following:

openjdk version "11.0.12" 2021-07-20
OpenJDK Runtime Environment (build 11.0.12+7-post-Debian-2)
OpenJDK 64-Bit Server VM (build 11.0.12+7-post-Debian-2, mixed mode, sharing)

### Start Jenkins

You can enable the Jenkins service to start at boot with the command:

```
sudo systemctl enable jenkins
```
You can start the Jenkins service with the command:

```
sudo systemctl start jenkins
```
You can check the status of the Jenkins service using the command:

```
sudo systemctl status jenkins
```
### Unlocking Jenkins

 After the installation you can access jenkins via this url: http://localhost:8080
 
 
<img width="475" alt="Screenshot 2022-08-14 123055" src="https://user-images.githubusercontent.com/78829346/184534690-b4d208e5-ae2b-4154-b0bc-797d8fe65553.png">

you can find the password by running this command:

```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
 ```
then you can click on "Install suggested plugins" - to install the recommended set of plugins, which are based on most common use cases.


## Create an entry in Manage Credentials for connecting to Nexus
> **_NOTE:_** you might to install first the following plugins:
> -  docker pipeline
> - kubernetes continuous deploy

Go to Jenkins --> Manage Jenkins--> Click on Manage Credentials.

![WhatsApp Image 2022-08-14 at 13 45 07](https://user-images.githubusercontent.com/78829346/184537540-5ed3814a-7f6d-439e-bdff-90299e6a8d2f.jpeg)

Enter Nexus user name and password with ID as nexus

![WhatsApp Image 2022-08-14 at 13 46 01](https://user-images.githubusercontent.com/78829346/184537551-0ad933fb-0f7c-4277-8d34-c239cec23c00.jpeg)

Click on Save.

###  Create an entry in Manage Credentials for connecting to Microk8s

Go to Jenkins --> Manage Jenkins--> Click on Manage Credentials.
then add credentials for microk8s

![WhatsApp Image 2022-08-14 at 13 49 28](https://user-images.githubusercontent.com/78829346/184537685-7d7d9898-9583-4aca-9bb2-f05395d6f9db.jpeg)

> **_NOTE:_**  if you don't know where to find the content of the kubconfig follow the following commands:

log in to the microk8s lxc container 

```
lxc exec microk8s -- sudo /bin/bash
```
then copy the folowing commands:

```
cd $HOME
mkdir .kube
cd .kube
microk8s config > config
sudo nano config
```
then copy the content of this file and paste it in the content on kubeconfig of jenkins credentials

![WhatsApp Image 2022-08-14 at 14 23 35](https://user-images.githubusercontent.com/78829346/184539167-49704032-0bea-4fc4-8a23-5123725ca2e6.jpeg)



##  CI / CD Create a pipeline in Jenkins

before creating the CI/CD pipeline we need to istall some plugins.
click on manage jenkins --> manage plugins --> available 

and install the following plugins:
- docker pipeline
- kubernetes continuous deploy


in jenkins dashbord click on new item
select pipeline and name it whatever you want

![WhatsApp Image 2022-08-14 at 13 52 28](https://user-images.githubusercontent.com/78829346/184537801-7546220d-9e59-460d-a7c6-e852ff5705de.jpeg)

click on Ok

Scroll down to the pipeline section and Copy the pipeline code from below
Make sure you change registryCredentials, registry and the url of the application tahta you want to deploy.
in this case we will deploy this springboot application: https://github.com/hakima-brf/customer-management-service


```
pipeline{
    
    agent any
    
    environment {
        imageName = "test"
        registryCredentials = "nexus"
        registry = "10.135.62.110:8083/"
        dockerImage = ''
    }
    
    stages {
        
        stage('checkout'){
            steps{
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/hakima-brf/customer-management-service']]])
            }
        }
        
        stage('build image'){
            steps{
                script{
                    dockerImage = docker.build imageName
                }
            }
        }
        
        stage('Uploading to Nexus') {
            steps{  
                script {
                    docker.withRegistry( 'http://'+registry, registryCredentials ) {
                    dockerImage.push('latest')
          }
        }
        
        
    }
    }
    
    
        stage('stop previous containers') {
            steps {
                sh 'docker ps -f name=customer-management-service -q | xargs --no-run-if-empty docker container stop'
                sh 'docker container ls -a -fname=customer-management-service -q | xargs -r docker container rm'
         }
       }
      
       stage('Docker Run') {
            steps{
                script {
                    sh 'docker run -d -p 90:90 --rm --name customer-management-service ' + registry + imageName
            }
         }
      }    
    
        stage('Deploy on kubernetes') {
            steps {
               script {
                    kubernetesDeploy (configs: 'customer-management-k8s-deployment.yml',kubeconfigId: 'kubeconfig')
            }
         }
      }
    
    }
}
```

this pipeline has four stages:
1) Checkout stage : this stage went to the url of the repository that we entered and check if it exists
2) Build image stage : this stage builds the docker image of the application 
3) Uploading to Nexus : this stage upload the docker image built to the nexus docker registry 
4) stop previous containers stage : this stage consists on stoping the previous containers
5) Docker Run stage :this stage runs the docker images
6) Deploy on kubernetes stage: this stages consists on deploying the application to the cubernetes cluster. make sure to change the configs parameter by the file YAML of your application 


click on apply then save

click on build now 

![WhatsApp Image 2022-08-14 at 21 59 36](https://user-images.githubusercontent.com/78829346/184554746-75a78923-dd5e-4da0-8000-0cf6d3e3ae93.jpeg)

if you find some errors in the stage of deployement you may need to downgrade some plugins to th efollowing:
* jackson2-api 2.10.3
* snakeyaml-api 1.26.3
* kubernetes continuous deploy 1.0.0

navigate to https://plugins.jenkins.io/ to download the plugins.
click on manage jenkins --> manage plugins --> advanced
in the deploy plugin choose the plugin that you downloaded before and deploy it.

![WhatsApp Image 2022-08-14 at 22 07 06](https://user-images.githubusercontent.com/78829346/184554910-df3e690c-de25-4b1a-8af4-a001b111a0ea.jpeg)

if the build is succesfull you can see that your application is added in nexus docker registry and deployed in the dashbord of microk8s.











