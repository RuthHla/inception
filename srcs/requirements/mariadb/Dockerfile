# OS minimal avec apt disponible
FROM debian:bookworm

# cmd shell pour appeler les bons paquets necessaires a limage, donc reflechir a quel paquet on a besoin
Run apt-get update -y && apt-get install mariadb-server -y

# quels fichiers necessaires pour notre base de donnees ?
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./tools/script.sh /usr/local/bin/script.sh

RUN chmod +x /usr/local/bin/script.sh

Expose 3306

# voir si il ya un nom dexecutable plus adapte
ENTRYPOINT ["/usr/local/bin/script.sh"]