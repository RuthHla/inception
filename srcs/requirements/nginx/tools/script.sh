#!/bin/sh

# - Générer la clé privée SSL
# - Créer et auto-signer le certificat HTTPS avec openssl
# - (optionnel) vérifier que php-fpm est joignable
# - Puis lancer nginx au premier plan (nginx -g 'daemon off;')

set -eu

mkdir -p /etc/nginx/ssl

if [ ! -f /etc/nginx/ssl/server.key ] || [ ! -f /etc/nginx/ssl/server.crt ]; then
  openssl req -x509 -newkey rsa:4096 \
    -keyout /etc/nginx/ssl/server.key \
    -out /etc/nginx/ssl/server.crt \
    -days 365 -nodes \
    -subj "/C=FR/O=My Company/CN=login.42.fr"
fi

exec nginx -g 'daemon off;'

# IMPORTANT -> le container reste vivant uniquement tant que le processus PID 1 tourne.
# Le premier plan sert uniquement à :
    # garder le container vivant
    # gérer correctement les signaux
    # éviter un daemon détaché