FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx openssl

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf
COPY tools/script.sh /usr/local/bin/mon_script.sh
RUN chmod +x /usr/local/bin/mon_script.sh

EXPOSE 443

# si fichier colle a la place precedemement alors lancer script 
# ou ne pas remplacer le fichier mais venir le modifier depuis le script
ENTRYPOINT ["/usr/local/bin/script.sh"]