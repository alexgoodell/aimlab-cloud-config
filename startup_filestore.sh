# basics
sudo apt update 
sudo apt install -y git make wget curl bison vim fish ncdu rsync bmon slurm tcptrack pipx nfs-common
sudo apt install -y nfs-kernel-server

# gh
sudo snap install gh

# setup nfs
sudo mkdir /share
sudo chown nobody:nogroup /share
sudo chmod 777 /share

sudo echo "/share *(rw,sync,no_subtree_check)" > /etc/exports
sudo systemctl restart nfs-kernel-server
sudo exportfs
