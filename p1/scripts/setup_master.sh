#!/bin/bash

sudo apt update -y && sudo apt upgrade -y

sudo apt install curl -y

sudo swapoff -a

curl -sfL https://get.k3s.io | sh -
CONFIG_FILE="/etc/rancher/k3s/k3s.yaml"

for i in {1..30}; do
    if [ -f "$CONFIG_FILE" ]; then
        echo "found Config File"
        break
    fi
    sleep 2
done

sudo chmod 644 /etc/rancher/k3s/k3s.yaml
sudo chown vagrant:vagrant /etc/rancher/k3s/k3s.yaml

echo "K3s (controller) installé avec succès sur Server"

/usr/local/bin/kubectl get nodes
