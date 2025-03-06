#!/bin/bash

sudo apt update -y && sudo apt upgrade -y

sudo apt install curl -y

sudo swapoff -a

NODE_IP=$(ip address | grep eth1 | grep 'inet ' | awk '{print $2}' | cut -d '/' -f1)

curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--node-ip=${NODE_IP}" sh -
CONFIG_FILE="/etc/rancher/k3s/k3s.yaml"
TOKEN_FILE="/var/lib/rancher/k3s/server/node-token"

for i in {1..30}; do
    if [ -f "$CONFIG_FILE" ]; then
        echo "found Config File"
        break
    fi
    sleep 2
done

sudo chmod 644 /etc/rancher/k3s/k3s.yaml
sudo chown vagrant:vagrant /etc/rancher/k3s/k3s.yaml

for i in {1..30}; do
  if [ -f "$TOKEN_FILE" ]; then
    echo "found Config File"
    break
  fi
  sleep 2
done
cat "$TOKEN_FILE" > /vagrant/token

echo "K3s (controller) installé avec succès sur Server"

/usr/local/bin/kubectl get nodes
