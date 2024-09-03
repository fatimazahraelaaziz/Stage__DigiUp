# Stage-digiup


The project is about the implementation of a devops solution for the deployment of a springboot application:


<img width="392" alt="archi" src="https://user-images.githubusercontent.com/78829346/184507048-d2f72ca8-daed-49e6-880f-1a3f69ed6eaa.png">

The tools used are:
- Lxc/lxd 
- Docker 
- Kubernetes (Microk8s)
- Jenkins
- Docker registry
- Github
- The application to be deployed

In this case we worked on a virtual machine that has as an OS ubuntu:22.04 in which we created the following lxc containers:

<img width="1207" alt="Screenshot 2024-07-13 at 22 00 50" src="https://github.com/user-attachments/assets/836322af-32ca-43c0-94db-57cb043cdbb2">

- private-docker-registry: for the docker registry where we will store the docker images of the application to deploy
- ngpm: for the reverse proxy
- mongodb: for the database
- microk8s: for the cluster kubernetes where the application will be deployed then being accessible from the network



