FROM debian:bookworm

Run apt-get update -y && apt-get install mariadb-server -y

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./tools/script.sh /usr/local/bin/script.sh

RUN chmod +x /usr/local/bin/script.sh

Expose 3306 

# excute forcement le script alors que CMD non
ENTRYPOINT ["/usr/local/bin/script.sh"]