#!/bin/sh
set -ex

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

first_run=0
if [ ! -d /var/lib/mysql/mysql ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql --auth-root-authentication-method=normal
    first_run=1
fi

mysqld --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &

until mariadb-admin --socket=/run/mysqld/mysqld.sock ping >/dev/null 2>&1; do
    sleep 1
done
#pour les tests uniquement
mariadb --socket=/run/mysqld/mysqld.sock -uroot -e "SHOW GRANTS FOR 'root'@'localhost';"

if [ "$first_run" -eq 1 ]; then
    mariadb --socket=/run/mysqld/mysqld.sock -uroot <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('${MYSQL_ROOT_PASSWORD}');
FLUSH PRIVILEGES;
EOF
fi

mariadb --socket=/run/mysqld/mysqld.sock -uroot -p"${MYSQL_ROOT_PASSWORD}" <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

mariadb-admin --socket=/run/mysqld/mysqld.sock -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown

exec mysqld --user=mysql
