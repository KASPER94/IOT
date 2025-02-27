📌 Inception of Things (IoT)
📖 Introduction

Inception of Things est un projet visant à approfondir les connaissances en administration système et en orchestration Kubernetes à l’aide de K3s, K3d, Vagrant et Argo CD. Ce projet permet d’apprendre à déployer des machines virtuelles, configurer un cluster Kubernetes léger et automatiser le déploiement d’applications.
🏗️ Objectifs

    🚀 Déployer et configurer un cluster Kubernetes minimaliste avec K3s et K3d.
    🔄 Automatiser la gestion des machines virtuelles avec Vagrant.
    🌐 Déployer et gérer trois applications web sous K3s avec un Ingress Controller.
    🎯 Mettre en place un pipeline de CI/CD avec Argo CD.
    🎁 (Bonus) Intégrer GitLab pour une gestion avancée des déploiements.

📂 Structure du projet

Le projet est organisé en plusieurs parties obligatoires et une partie bonus :

📂 inception-of-things
 ├── 📁 p1  # Partie 1 - K3s et Vagrant
 │   ├── Vagrantfile
 │   ├── 📂 scripts
 │   └── 📂 confs
 ├── 📁 p2  # Partie 2 - K3s et trois applications
 │   ├── K3s configuration files
 │   ├── 📂 scripts
 │   └── 📂 confs
 ├── 📁 p3  # Partie 3 - K3d et Argo CD
 │   ├── K3d configuration files
 │   ├── 📂 scripts
 │   └── 📂 confs
 ├── 📁 bonus  # (Bonus) Intégration de GitLab
 │   ├── GitLab configuration
 │   ├── 📂 scripts
 │   └── 📂 confs
 ├── README.md
 └── .gitignore

🛠️ Technologies utilisées

    Vagrant 🏗️ : Automatisation de machines virtuelles.
    K3s 🏢 : Distribution légère de Kubernetes.
    K3d ⚡ : Kubernetes en mode Docker.
    Argo CD 🚀 : Déploiement continu (GitOps).
    Ingress Controller 🌍 : Gestion du trafic réseau.
    GitHub/GitLab 🛠️ : Gestion des versions et intégration CI/CD.

⚙️ Installation et Déploiement
📌 Prérequis

Assurez-vous d’avoir les outils suivants installés sur votre machine :

Vagrant 🏗️
VirtualBox 🖥️
Docker 🐳
kubectl ⌨️
K3s / K3d 🏢
Argo CD 🚀
Git 🔗

🚀 Étapes d’installation
1️⃣ Déployer les machines virtuelles avec Vagrant

cd p1
vagrant up
vagrant ssh

2️⃣ Installer et configurer K3s

Sur la machine Server :

curl -sfL https://get.k3s.io | sh -
kubectl get nodes

Sur la machine ServerWorker :

curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=<TOKEN> sh -

3️⃣ Déployer les applications web sur K3s

kubectl apply -f p2/app1.yaml
kubectl apply -f p2/app2.yaml
kubectl apply -f p2/app3.yaml
kubectl get pods

4️⃣ Installer et configurer K3d + Argo CD

k3d cluster create mycluster
kubectl create namespace argocd
kubectl apply -n argocd -f p3/argocd-install.yaml
kubectl port-forward svc/argocd-server -n argocd 8080:443

5️⃣ Bonus - Intégration GitLab (CI/CD avancé)

helm repo add gitlab https://charts.gitlab.io/
helm install gitlab gitlab/gitlab -n gitlab

📊 Fonctionnalités

    📌 Déploiement Kubernetes avec K3s et K3d.
    📡 Gestion du trafic avec Ingress Controller.
    🔄 CI/CD automatisé avec Argo CD.
    🔧 Gestion des machines virtuelles avec Vagrant.
    🖥️ Monitoring des ressources et applications.
    🎁 Bonus : Intégration GitLab pour CI/CD avancé.