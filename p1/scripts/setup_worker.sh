#!/bin/bash

sudo apt update -y && sudo apt upgrade -y
sudo apt install curl -y

sudo swapoff -a

SERVER_IP="192.168.56.110"
# TOKEN=$(ssh -o StrictHostKeyChecking=no vagrant@$SERVER_IP "sudo cat /var/lib/rancher/k3s/server/node-token")
TOKEN=$(cat /vagrant/token)

curl -sfL https://get.k3s.io | K3S_URL="https://$SERVER_IP:6443" K3S_TOKEN="$TOKEN" INSTALL_K3S_EXEC="--node-ip=${SERVER_IP}" sh -

echo "K3s (agent) installé avec succès sur ServerWorker"
