#!/bin/sh

set -ex

echo "===> Start WordPress init"

mkdir -p /var/www/html
cd /var/www/html

echo "===> Current directory:"
pwd
ls -la

rm -f /var/www/html/index.nginx-debian.html

# echo "===> Waiting for MariaDB..."
# until mariadb -hmariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" -e "SELECT 1;" >/dev/null 2>&1; do
#     sleep 2
# done
# echo "===> MariaDB OK"

echo "===> Waiting for MariaDB server..."
until mariadb-admin ping -hmariadb --silent; do
    sleep 2
done
echo "===> MariaDB server is reachable"

echo "===> wp binary:"
which wp
wp --allow-root --info

if [ ! -f wp-load.php ]; then
    echo "===> Downloading WordPress core"
    wp core download --allow-root --path=/var/www/html
fi

echo "===> Files after download:"
ls -la /var/www/html

if [ ! -f wp-config.php ]; then
    echo "===> Creating wp-config.php"
    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="mariadb:3306" \
        --path=/var/www/html \
        --allow-root
fi

if ! wp core is-installed --allow-root --path=/var/www/html; then
    echo "===> Installing WordPress"
    wp core install \
        --url="$DOMAIN_NAME" \
        --title="Inception" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --path=/var/www/html \
        --allow-root

    if ! wp user get "$WP_USER" --allow-root --path=/var/www/html >/dev/null 2>&1; then
        echo "===> Creating second user"
        wp user create \
            "$WP_USER" \
            "$WP_USER_EMAIL" \
            --role=author \
            --user_pass="$WP_USER_PASSWORD" \
            --path=/var/www/html \
            --allow-root
    fi
fi

echo "===> Setting permissions"
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

echo "===> Final files:"
ls -la /var/www/html

echo "===> Launching php-fpm"
exec php-fpm8.2 -F

# #!/bin/sh

# # 1. Vérifie si WordPress est déjà installé
# # 2. Sinon :
# #      télécharge WordPress
# #      configure la base
# #      installe WordPress
# #      crée deux utilisateurs
# # 3. Lance php-fpm

# set -e

# #va dans /var/www/html par defaut. WP-CLI bloque root normalement pour eviter pb de scurite
# cd /var/www/html

# rm -f /var/www/html/index.nginx-debian.html

# until mariadb -hmariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" -e "SELECT 1;" >/dev/null 2>&1; do
#     sleep 2
# done

# if [ ! -f wp-load.php ]; then
#     wp core download --allow-root
# fi

# #genere fichier wp-config.php (co avec DB, cle de scurite, conf wordpress)
# if [ ! -f wp-config.php ]; then
#     wp config create \
#         --dbname="$MYSQL_DATABASE" \
#         --dbuser="$MYSQL_USER" \
#         --dbpass="$MYSQL_PASSWORD" \
#         --dbhost="mariadb:3306" \
#         --allow-root
# fi

# #initialise la base + cree tables wordpress + cree user admin
# if ! wp core is-installed --allow-root; then
#     wp core install \
#         --url="$DOMAIN_NAME" \
#         --title="Inception" \
#         --admin_user="$WP_ADMIN_USER" \
#         --admin_password="$WP_ADMIN_PASSWORD" \
#         --admin_email="$WP_ADMIN_EMAIL" \
#         --allow-root

# #sujet impose 2 users dans la data base
#     if ! wp user get "$WP_USER" --allow-root >/dev/null 2>&1; then
#         wp user create \
#             "$WP_USER" \
#             "$WP_USER_EMAIL" \
#             --role=author \
#             --user_pass="$WP_USER_PASSWORD" \
#             --allow-root
#     fi
# fi

# chown -R www-data:www-data /var/www/html
# find /var/www/html -type d -exec chmod 755 {} \;
# find /var/www/html -type f -exec chmod 644 {} \;

# exec php-fpm8.2 -F #serveur PHP/version/foreground(PID 1 doit rester actif)