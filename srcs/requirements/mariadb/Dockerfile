FROM debian:bookworm

RUN apt-get update -y \
    && apt-get install -y mariadb-server \
    && mkdir -p /run/mysqld \
    && chown -R mysql:mysql /run/mysqld /var/lib/mysql \
    && rm -rf /var/lib/mysql/* \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./tools/script.sh /usr/local/bin/script.sh

RUN chmod +x /usr/local/bin/script.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/script.sh"]

# FROM debian:bookworm

# RUN apt-get update -y && apt-get install mariadb-server -y

# COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
# COPY ./tools/script.sh /usr/local/bin/script.sh

# RUN chmod +x /usr/local/bin/script.sh

# EXPOSE 3306 

# ENTRYPOINT ["/usr/local/bin/script.sh"]