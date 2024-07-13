# stage-digiup


the project is about the implementation of a devops solotion for the deploeyement of a springboot application:


<img width="392" alt="archi" src="https://user-images.githubusercontent.com/78829346/184507048-d2f72ca8-daed-49e6-880f-1a3f69ed6eaa.png">

the tools used are:
- Lxc/lxd 
- Docker 
- Kubernetes (Microk8s)
- Jenkins
- Docker registry
- ELK- elasticsearch / kibana / filebeat for monitoring
- github
- the application to be deployed

in this case we worked on a virtual machine that has as an OS ubuntu:22.04 in which we created the following lxc containers:

![WhatsApp Image 2022-08-13 at 20 20 05](https://user-images.githubusercontent.com/78829346/184507853-e24b6724-87f4-43d9-a73e-545e183eac89.jpeg)


- private-docker-registry: for the docker registry where we will store the docker images of the application to deploy
- ngpm: for the reverse proxy
- mongodb: for tha database
- microk8s: for the cluster kubernetes where the application will be deployed then being accessible from the network
- esk: for elasticsearch and kibana tnat will serve for the monitoring




