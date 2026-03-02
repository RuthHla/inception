#!/bin/bash

# Creer le dossier pour la socket
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

# Connexion base de donnee + creation de la base en mode reseau local
mysqld --skip-networking --socket=/run/mysqld/mysqld.sock & #demarrer le serveur + desactiver TCP + communiquer a travers socket (entre fichier 100% local)

until mariadb --socket=/run/mysqld/mysqld.sock -uroot -e "SELECT 1;" >/dev/null 2>&1; do #tant que le serveur ne retourne pas 1 on reitere
  sleep 1
done

mariadb --socket=/run/mysqld/mysqld.sock -uroot -e "
CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER IF NOT EXISTS 'wp_user'@'%' IDENTIFIED BY 'wp_pass';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'%';
FLUSH PRIVILEGES;
"

mariadb-admin --socket=/run/mysqld/mysqld.sock -uroot shutdown

# relancer en ecouter les plages
exec mysqld

