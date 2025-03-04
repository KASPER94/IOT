#!/bin/bash

#verif
echo "Initialisation du projet P3 avec K3d et Argo CD..."
if ! command -v k3d &> /dev/null
then
    echo "❌ K3d n'est pas installé. Exécute 'make install_k3d' d'abord."
    exit 1
fi
if ! command -v kubectl &> /dev/null
then
    echo "❌ Kubectl n'est pas installé. Exécute 'make install_kubectl' d'abord."
    exit 1
fi
if ! docker info &> /dev/null
then
    echo "❌ Docker ne semble pas fonctionner. Assure-toi qu'il est bien lancé."
    exit 1
fi

echo "Création du cluster Kubernetes avec K3d..."
k3d cluster create mycluster --servers 1 --agents 1

echo "Cluster K3d créé avec succès !"

echo "Installation d'Argo CD..."
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Attente du démarrage des pods Argo CD..."
kubectl wait --for=condition=Available --timeout=300s deployment -l app.kubernetes.io/name=argocd-server -n argocd

echo "Argo CD installé avec succès !"

echo "Récupération du mot de passe Argo CD..."
ARGOCD_PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d)
echo "Mot de passe Argo CD : $ARGOCD_PASSWORD" > p3/argocd_password.txt

echo "Exposition du serveur Argo CD en local..."
kubectl port-forward svc/argocd-server -n argocd 8080:443 &

echo "Création du namespace dev..."
kubectl create namespace dev

echo "Initialisation du projet terminée !"
echo "Access ArgoCD : https://localhost:8080"
echo "Le mot de passe est enregistré dans 'argocd_password.txt'"

echo "Déploiement des fichiers de configuration Kubernetes..."
kubectl apply -f p3/manifests/dev/namespace.yaml
kubectl apply -f p3/manifests/dev/deployment.yaml
kubectl apply -f p3/manifests/dev/service.yaml
kubectl apply -f p3/manifests/dev/ingress.yaml

echo "Ajout de l'application à Argo CD..."
kubectl apply -f p3/manifests/application.yaml -n argocd

echo "Synchronisation de l'application avec Argo CD..."
argocd app sync my-app

echo "Statut de l'application Argo CD:"
argocd app get my-app