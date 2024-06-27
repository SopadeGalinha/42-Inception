FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y wget\
	php7.4 php7.4-fpm php7.4-mysql php7.4-gd php7.4-opcache\
	php7.4-cli php7.4-curl php7.4-mbstring

COPY ./conf/www.conf /tmp/www.conf
COPY ./tools/entrypoint.sh /tmp/entrypoint.sh

RUN chmod +x /tmp/entrypoint.sh
RUN chmod +x /tmp/www.conf

ENTRYPOINT ["sh", "/tmp/entrypoint.sh"]
