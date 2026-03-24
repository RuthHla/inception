FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx openssl

COPY conf/default.cnf /etc/nginx/conf.d/default.conf
COPY tools/script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/script.sh"]