#!/bin/sh

set -ex

echo "===> Start WordPress init"

mkdir -p /var/www/html
cd /var/www/html

rm -f /var/www/html/index.nginx-debian.html

echo "===> Waiting for MariaDB..."
until mariadb -hmariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" -e "SELECT 1;" >/dev/null 2>&1; do
    sleep 2
done
echo "===> MariaDB OK"

if [ ! -f wp-load.php ]; then
    echo "===> Downloading WordPress core"
    wp core download --allow-root --path=/var/www/html
fi

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
        --url="https://$DOMAIN_NAME" \
        --title="Inception" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --path=/var/www/html \
        --allow-root
fi

echo "===> Updating WordPress URLs"
wp option update home "https://$DOMAIN_NAME" --allow-root --path=/var/www/html
wp option update siteurl "https://$DOMAIN_NAME" --allow-root --path=/var/www/html

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

echo "===> Setting permissions"
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

echo "===> Launching php-fpm"
exec php-fpm8.2 -F
