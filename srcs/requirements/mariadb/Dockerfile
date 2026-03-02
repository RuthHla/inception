# OS minimal avec apt disponible
From debian-bullseye 

# cmd shell pour appeler les bons paquets necessaires a limage, donc reflechir a quel paquet on a besoin
Run apt-get update -y && apt-get install mariadb-server -y

# quels fichiers necessaires pour notre base de donnees ?
COPY ./tools/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./tools/script.sh /

Expose 3306

# voir si il ya un nom dexecutable plus adapte
Entrypoint ["./maria_container"]