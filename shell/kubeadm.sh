#!/usr/bin/env bash

IP_ADDRESS=$1
USER=$2
USER_HOME=$3
GROUP=$4

kubeadm config images pull
kubeadm init --apiserver-advertise-address="$IP_ADDRESS" --pod-network-cidr=10.244.0.0/16 | tee /mnt/setuplog/kubeadm.log
sudo -u "$USER" mkdir -p "$USER_HOME"/.kube
cp /etc/kubernetes/admin.conf "$USER_HOME"/.kube/config
cp /etc/kubernetes/admin.conf /vagrant/conf/admin.conf
chown "$USER":"$GROUP" "$USER_HOME"/.kube/config
sysctl net.bridge.bridge-nf-call-iptables=1
# General user
sudo -u "$USER" -i /vagrant/shell/network-plugin.sh
# node setup
sudo -u "$USER" -i /vagrant/shell/nodesetup.sh
