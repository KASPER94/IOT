#!/bin/bash


if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Vérifier si l'authtoken est bien défini
if [ -z "$NGROK_AUTHTOKEN" ]; then
    echo " ERREUR : NGROK_AUTHTOKEN n'est pas défini dans le fichier .env."
    exit 1
fi

# Vérifier si ngrok est installé
# if ! command -v ngrok &> /dev/null; then
#     echo "Ngrok n'est pas installé. Installe-le d'abord avec :"
#     echo "curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc > /dev/null"
#     echo "echo 'deb https://ngrok-agent.s3.amazonaws.com buster main' | sudo tee /etc/apt/sources.list.d/ngrok.list"
#     echo "sudo apt update && sudo apt install ngrok"
#     exit 1
# fi

ngrok config add-authtoken $NGROK_AUTHTOKEN
# Vérifier si un tunnel ngrok est déjà actif
if pgrep -x "ngrok" > /dev/null; then
    echo " Ngrok tourne déjà."
else
    echo " Démarrage de ngrok..."
    ngrok http https://localhost:8080 > /dev/null &
    # ngrok http 8080 --bind-tls=true > /dev/null 2>&1 &
    # ngrok http --url=fair-flounder-completely.ngrok-free.app 7777 --host-header=localhost > /dev/null &
    sleep 5  # Laisser le temps à ngrok pour générer l'URL
fi

# Récupérer l'URL publique de ngrok
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r .tunnels[0].public_url)

# Vérifier si l'URL est bien récupérée
if [[ -z "$NGROK_URL" || "$NGROK_URL" == "null" ]]; then
    echo "Erreur : Impossible de récupérer l'URL publique de ngrok."
    exit 1
fi

echo "Argo CD est accessible via : $NGROK_URL"
echo "$NGROK_URL" > p3/ngrok_url.txt
