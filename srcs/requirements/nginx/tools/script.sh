# - Générer la clé privée SSL
# - Créer et auto-signer le certificat HTTPS avec openssl
# - (optionnel) vérifier que php-fpm est joignable
# - Puis lancer nginx au premier plan (nginx -g 'daemon off;')

#!/bin/sh
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


#!/bin/sh                                                                           // doit etre execute en sh
# set -eu                                                                           // si cmd echoue ou variable non defnie utilisee alors arret direct 
# mkdir -p /etc/nginx/ssl                                                           // creation du dossier ssl si pas deja existant  
# if [ ! -f /etc/nginx/ssl/server.key ] || [ ! -f /etc/nginx/ssl/server.crt ]; then // si certif ou cle existe pas 
#   openssl req -x509 -newkey rsa:4096 \                                            // creation certif / outil pour creer reauete,certificat / cree direct un certif autosigne x.509 au lieu de requete / genere nvl cle RSA 4096bits
#     -keyout /etc/nginx/ssl/server.key \                                           // chemin stockage de la cle
#     -out /etc/nginx/ssl/server.crt \                                              // chemin stockage certif public auto-signe
#     -days 365 -nodes \                                                            // cetif valable 365j / cle privee non chiffre (sinn need passphrase au launch)
#     -subj "/C=FR/O=My Company/CN=login.42.fr"                                     // remplir sujet direct du certif au liue interaction avec ce dernier/ C=Fr O= My company CN=login.42.fr  
# fi                                                                                // fin du bloc if
# exec nginx -g 'daemon off;'                                                       // nginx devient le PID 1 dans le conteneur, (launch nginx au 1er plan)

# IMPORTANT -> le container reste vivant uniquement tant que le processus PID 1 tourne.
# Le premier plan sert uniquement à :
    # garder le container vivant
    # gérer correctement les signaux
    # éviter un daemon détaché