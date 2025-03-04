.PHONY: all install_deps install_vagrant install_k3s install_ansible install_python install_k3d install_kubectl p3 stop_p3 install_docker

all: install_deps install_vagrant install_k3s install_ansible install_python install_k3d install_kubectl

install_deps:
	@echo "📦 Mise à jour du système et installation des outils de base..."
	sudo apt update && sudo apt upgrade -y
	sudo apt install -y curl wget git unzip apt-transport-https ca-certificates gnupg lsb-release software-properties-common
	@echo "✅ Dépendances système installées."

install_vagrant:
	@echo "📦 Installation de Vagrant et VirtualBox..."
	sudo apt install -y vagrant
	wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg
	echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian bookworm contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
	sudo apt update
	sudo apt install virtualbox-7.0 -y
	@echo "✅ Vagrant et VirtualBox installés avec succès."

install_k3s:
	@echo "📦 Installation de K3s..."
	curl -sfL https://get.k3s.io | sh -
	sudo chmod 644 /etc/rancher/k3s/k3s.yaml
	sudo chown $(USER):$(USER) /etc/rancher/k3s/k3s.yaml
	@if [ -f ~/.bashrc ]; then \
		echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> ~/.bashrc; \
		. ~/.bashrc; \
	elif [ -f ~/.zshrc ]; then \
		echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> ~/.zshrc; \
		. ~/.zshrc; \
	else \
		echo "Erreur: Aucun fichier .bashrc ou .zshrc trouvé"; \
		exit 1; \
	fi

	kubectl version --client
	@echo "✅ K3s et kubectl installés avec succès."

install_ansible:
	@echo "📦 Installation d'Ansible..."
	sudo apt install -y ansible
	ansible --version
	@echo "✅ Ansible installé avec succès."

install_python:
	@echo "📦 Installation des dépendances Python pour Ansible..."
	# sudo apt install -y python3 python3-pip
	# pip3 install --upgrade pip
	# pip3 install ansible-core paramiko cryptography
	sudo apt install -y pipx
	pipx install ansible-core
	pipx inject ansible-core paramiko cryptography
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

reinstall_kubectl_p3:
	@if [ -f /usr/local/bin/kubectl ]; then \
		sudo rm -f /usr/local/bin/kubectl; \
	fi
	curl -LO "https://dl.k8s.io/release/v1.32.2/bin/linux/amd64/kubectl"
	chmod +x kubectl
	sudo mv kubectl /usr/local/bin/



install_docker:
	# Add the repository to Apt sources:
	echo "deb [arch=$(shell dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bookworm stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update
	sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
	sudo docker run hello-world
	sudo usermod -aG docker $USER
	newgrp docker

install_ngrok:
	curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
	| sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
	&& echo "deb https://ngrok-agent.s3.amazonaws.com buster main" \
	| sudo tee /etc/apt/sources.list.d/ngrok.list \
	&& sudo apt update \
	&& sudo apt install ngrok

p3:
	chmod +x p3/script_run.sh
	./p3/script_run.sh

stop_p3:
	rm -rf p3/argocd_password.txt
	k3d cluster stop mycluster
	k3d cluster delete mycluster




