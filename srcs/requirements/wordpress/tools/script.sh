# 1. Vérifie si WordPress est déjà installé
# 2. Sinon :
#      télécharge WordPress
#      configure la base
#      installe WordPress
#      crée deux utilisateurs
# 3. Lance php-fpm

#!/bin/sh

set -e

if [ ! -f wp-config.php ]; then

#va dans /var/ww/html par defaut. WP-CLI bloque root normalement pour evier pb de scurite
wp core download --allow-root

#genere fichier wp-config.php (co avec DB, cle de scurite, conf wordpress)
wp config create \
 --dbname=$MYSQL_DATABASE \
 --dbuser=$MYSQL_USER \
 --dbpass=$MYSQL_PASSWORD \
 --dbhost=mariadb \
 --allow-root

#initialise la base + cree tables wordpress + cree user admin
wp core install \
 --url=$DOMAIN_NAME \
 --title="Inception" \
 --admin_user=$WP_ADMIN_USER \
 --admin_password=$WP_ADMIN_PASSWORD \
 --admin_email=$WP_ADMIN_EMAIL \
 --allow-root

#sujet impose 2 users dans la data base
wp user create \
 $WP_USER \
 $WP_USER_EMAIL \
 --user_pass=$WP_USER_PASSWORD \
 --allow-root

fi

php-fpm8.2 -F #serveur PHP/version/foreground(PID 1 doit rester actif)