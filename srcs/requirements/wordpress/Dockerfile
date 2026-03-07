FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    curl \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf

COPY tools/script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

WORKDIR /var/www/html

ENTRYPOINT ["/usr/local/bin/script.sh"]