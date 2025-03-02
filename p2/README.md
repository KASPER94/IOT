🚀 Démarrer le projet P2 et vérifier que tout fonctionne
1️⃣ Lancer la VM avec Vagrant
📌 Dans ton terminal, exécute les commandes suivantes :
cd mon_projet_k3s_p2  # Aller dans le dossier du projet
vagrant up            # Démarrer la VM et provisionner K3s + Ansible
✅ Ce que fait vagrant up :

Crée la VM Debian (debian/bookworm64) avec IP 192.168.56.110
Installe Ansible
Installe K3s
Déploie les applications (app1.yaml, app2.yaml, app3.yaml)
Configure l'Ingress (ingress.yaml) pour router les requêtes

2️⃣ Vérifier que K3s fonctionne
📌 Se connecter à la VM :
vagrant ssh server
📌 Vérifier si K3s est bien installé :
kubectl get nodes
✅ Résultat attendu :
NAME      STATUS   ROLES                  AGE   VERSION
server    Ready    control-plane,master   XXm   vX.XX.X+k3s
✅ Si STATUS = Ready, ton cluster fonctionne ! 🎉

3️⃣ Vérifier si les applications sont déployées
📌 Lister les pods (applications) :
kubectl get pods
✅ Sortie attendue :
NAME                      READY   STATUS    RESTARTS   AGE
app1-XXXXXX               1/1     Running   0          XXm
app2-XXXXX-XXXXX          1/1     Running   0          XXm
app2-XXXXX-XXXXX          1/1     Running   0          XXm
app2-XXXXX-XXXXX          1/1     Running   0          XXm
app3-XXXXX                1/1     Running   0          XXm
📌 Explication :

App1 → 1 pod (Nginx ou Flask)
App2 → 3 pods (réplicas d’Apache ou Express)
App3 → 1 pod (Nginx ou Redis)

4️⃣ Vérifier les services
📌 Lister les services Kubernetes :
kubectl get svc
✅ Sortie attendue :
NAME           TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
app1-service   ClusterIP   10.43.XXX.XX   <none>        80/TCP    XXm
app2-service   ClusterIP   10.43.XXX.XX   <none>        80/TCP    XXm
app3-service   ClusterIP   10.43.XXX.XX   <none>        80/TCP    XXm

📌 Vérifie que chaque service est bien créé et exposé sur le bon port (80/TCP).

5️⃣ Vérifier que l’Ingress fonctionne avec Traefik
📌 Lister les Ingress configurés :
kubectl get ingress
✅ Sortie attendue :
NAME         CLASS    HOSTS          ADDRESS         PORTS   AGE
my-ingress   <none>   app1.com,...   192.168.56.110  80      XXm
📌 Vérifie que :

L’Ingress my-ingress est bien créé
Il route app1.com, app2.com, app3.com vers 192.168.56.110
Le port 80 est bien actif

6️⃣ Tester les accès aux applications
📌 Sur ta machine hôte (pas dans la VM), ajoute ces lignes à /etc/hosts :
echo "192.168.56.110 app1.com" | sudo tee -a /etc/hosts
echo "192.168.56.110 app2.com" | sudo tee -a /etc/hosts
echo "192.168.56.110 app3.com" | sudo tee -a /etc/hosts

Ça permet d’accéder aux applications via http://app1.com, http://app2.com, http://app3.com 

📌 Tester avec curl :
curl -H "Host: app1.com" http://192.168.56.110
✅ Résultat attendu (exemple Nginx) :
<!DOCTYPE html>
<html>
<head><title>Welcome to nginx!</title></head>
<body><h1>It works!</h1></body>
</html>

📌 Tester app2 et app3 :
curl -H "Host: app2.com" http://192.168.56.110
curl -H "Host: app3.com" http://192.168.56.110


7️⃣ Accéder au tableau de bord de Traefik
📌 Exposer Traefik pour voir les routes :
kubectl port-forward -n kube-system deployment/traefik 8080:8080
📌 Ouvrir dans un navigateur :
http://localhost:8080/dashboard/
