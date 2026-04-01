#!/bin/sh

set -eu

mkdir -p /etc/nginx/ssl

sed -i "s|\${DOMAIN_NAME}|$DOMAIN_NAME|g" /etc/nginx/conf.d/default.conf

if [ ! -f /etc/nginx/ssl/server.key ] || [ ! -f /etc/nginx/ssl/server.crt ]; then
  openssl req -x509 -newkey rsa:4096 \
    -keyout /etc/nginx/ssl/server.key \
    -out /etc/nginx/ssl/server.crt \
    -days 365 -nodes \
    -subj "/C=FR/O=My Company/CN=$DOMAIN_NAME" #pense a remplacer par $DOMAIN_NAME
fi

exec nginx -g 'daemon off;'
