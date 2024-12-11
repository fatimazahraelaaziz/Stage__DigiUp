# LXC/LXC containers installation 
> **Note:** These steps have been tested on Ubuntu 22.04 
### Install the snap package
```
sudo snap install lxd --channel=4.0/stable
```
### Initial configuration
```
sudo lxd init
```
> **Note:** leave everything on default except this: 
> Name of the storage backend to use (btrfs, dir, lvm) [default=btrfs]: dir

#### for UBUNTU 20.04 you might need to add these commands
```
sudo apt-get update && sudo apt-get install lxc -y
```


  
