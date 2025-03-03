#!/bin/bash

sudo apt update -y && sudo apt upgrade -y

sudo swapoff -a

curl -sfL https://get.k3s.io | sh -

sudo chmod 644 /etc/rancher/k3s/k3s.yaml
sudo chown vagrant:vagrant /etc/rancher/k3s/k3s.yaml

echo "K3s (controller) installé avec succès sur Server"

/usr/local/bin/kubectl get nodes
