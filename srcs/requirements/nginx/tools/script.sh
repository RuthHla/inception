#!/bin/sh

set -eu

mkdir -p /etc/nginx/ssl

if [ ! -f /etc/nginx/ssl/server.key ] || [ ! -f /etc/nginx/ssl/server.crt ]; then
  openssl req -x509 -newkey rsa:4096 \
    -keyout /etc/nginx/ssl/server.key \
    -out /etc/nginx/ssl/server.crt \
    -days 365 -nodes \
    -subj "/C=FR/O=My Company/CN=alandel.42.fr"
fi

exec nginx -g 'daemon off;'
