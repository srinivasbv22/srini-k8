#!/bin/bash

# update and upgrade
apt update -y && apt upgrade -y

# install docker
apt install docker.io -y

# Setup daemon.
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

# Restart docker.
systemctl daemon-reload
systemctl restart docker

# Install kubernetes CLI 
apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list

apt update -y
apt-get install -y  kubelet kubeadm kubectl kubernetes-cni nfs-common
sysctl net.bridge.bridge-nf-call-iptables=1

swapoff -a

rm -rf /var/lib/kubelet/*
apt-get install nfs-common -y
