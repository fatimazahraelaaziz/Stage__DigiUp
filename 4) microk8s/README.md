# Microk8s

in this step we will set up a kubernetes cluster using microk8s

![k8s+microk8s](https://user-images.githubusercontent.com/78829346/184512074-2c43e4bc-6517-46cc-9a63-b819593cd7b6.svg)

## Add the MicroK8s LXD profile

MicroK8s requires some specific settings to work within LXD . These can be applied using a custom profile. The first step is to create a new profile to use:

```
lxc profile create microk8s
```
Once created, we’ll need to add the rules
Download the profile:

```
wget https://raw.githubusercontent.com/ubuntu/microk8s/master/tests/lxc/microk8s.profile -O microk8s.profile
```
We can now pipe that file into the LXD profile.

```
cat microk8s.profile | lxc profile edit microk8s
```
And then clean up.

```
rm microk8s.profile
```

## Start an LXD container for MicroK8s

We can now create the container that MicroK8s will run in.

```
lxc launch -p default -p microk8s ubuntu:20.04 microk8s
```

> **_NOTE:_** Note that this command uses the ‘default’ profile, for any existing system settings (networking, storage, etc.) before also applying the ‘microk8s’ profile - the order is important.

## Install MicroK8s in an LXD container

First, we’ll need to install MicroK8s within the container.

```
lxc exec microk8s -- sudo snap install microk8s --classic
```

## Load AppArmor profiles on boot

To automate the profile loading first enter the LXD container with:

```
lxc shell microk8s
```
Then create an rc.local file to perform the profile loading:

```
cat > /etc/rc.local <<EOF
#!/bin/bash

apparmor_parser --replace /var/lib/snapd/apparmor/profiles/snap.microk8s.*
exit 0
EOF
```
Make the rc.local executable:

```
chmod +x /etc/rc.local
```
## Exposing Services To Node

You’ll need to expose the deployment or service to the container itself before you can access it via the LXD container’s IP address. This can be done using kubectl expose. This example will expose the deployment’s port 80 to a port assigned by Kubernetes.

### Microbot

In this example, we will use Microbot as it provides a simple HTTP endpoint to expose. These steps can be applied to any other deployment.

First, let’s deploy Microbot (please note this image only works on x86_64).

```
lxc exec microk8s -- sudo microk8s kubectl create deployment microbot --image=dontrebootme/microbot:v1

```
Then check that the deployment has come up.

```
lxc exec microk8s -- sudo microk8s kubectl get all
```
the output looks llike this
```
NAME                            READY   STATUS    RESTARTS   AGE
pod/microbot-6d97548556-hchb7   1/1     Running   0          21m

NAME                       TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
service/kubernetes         ClusterIP   10.152.183.1     <none>        443/TCP        21m

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/microbot   1/1     1            1           21m

NAME                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/microbot-6d97548556   1         1         1       21m
```
As we can see, Microbot is running. Let’s expose it to the LXD container.

```
lxc exec microk8s -- sudo microk8s kubectl expose deployment microbot --type=NodePort --port=80 --name=microbot-service

```
We can now get the assigned port. In this example, it’s 32750.

```
lxc exec microk8s -- sudo microk8s kubectl get service microbot-service

```
```
NAME               TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
microbot-service   NodePort   10.152.183.188   <none>        80:32750/TCP   27m
```
With this, we can access Microbot from our host but using the container’s address that we noted earlier.

```
curl 10.245.108.37:32750

```
or we can browse 10.245.108.37:32750 in the navigator.

## Dashboard

The dashboard addon has a built in helper. Start the Kubernetes dashboard

```
lxc exec microk8s -- microk8s dashboard-proxy
```
and replace 127.0.0.1 with the container’s IP address we noted earlier.


![WhatsApp Image 2022-08-14 at 21 54 08](https://user-images.githubusercontent.com/78829346/184554585-a1200ab8-1013-4449-9194-9e6e8134808d.jpeg)


> **_NOTE:_** if it's the first time you use microk8s you will find only microbot in the deployements.


































