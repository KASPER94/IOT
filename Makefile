.PHONY: all install_deps install_vagrant install_k3s install_ansible install_python install_k3d install_kubectl p3 stop_p3

all: install_deps install_vagrant install_k3s install_ansible install_python install_k3d install_kubectl

install_deps:
	@echo "📦 Mise à jour du système et installation des outils de base..."
	sudo apt update && sudo apt upgrade -y
	sudo apt install -y curl wget git unzip apt-transport-https ca-certificates gnupg lsb-release software-properties-common
	@echo "✅ Dépendances système installées."

install_vagrant:
	@echo "📦 Installation de Vagrant et VirtualBox..."
	sudo apt install -y vagrant
	sudo apt-get install -y virtualbox-7.0
	vagrant --version
	@echo "✅ Vagrant et VirtualBox installés avec succès."

install_k3s:
	@echo "📦 Installation de K3s..."
	curl -sfL https://get.k3s.io | sh -
	sudo chmod 644 /etc/rancher/k3s/k3s.yaml
	sudo chown $USER:$USER /etc/rancher/k3s/k3s.yaml
	echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> ~/.bashrc
	source ~/.bashrc
	kubectl version --client
	@echo "✅ K3s et kubectl installés avec succès."

install_ansible:
	@echo "📦 Installation d'Ansible..."
	sudo apt install -y ansible
	ansible --version
	@echo "✅ Ansible installé avec succès."

install_python:
	@echo "📦 Installation des dépendances Python pour Ansible..."
	sudo apt install -y python3 python3-pip
	pip3 install --upgrade pip
	pip3 install ansible-core paramiko cryptography
	@echo "✅ Modules Python pour Ansible installés."

install_k3d:
	@echo "📦 Installation de k3d..."
	curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
	@echo "✅ K3d installé avec succès."

install_kubectl:
	@echo "📦 Installation de kubectl..."
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
	chmod +x kubectl
	sudo mv kubectl /usr/local/bin/
	@echo "✅ Kubectl installé avec succès."

p3:
	chmod +x p3/script_run.sh
	./p3/script_run.sh

stop_p3:
	rm -rf p3/argocd_password.txt
	k3d cluster stop mycluster
	k3d cluster delete mycluster




