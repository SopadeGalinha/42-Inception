FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y mariadb-server

RUN mkdir -p /var/run/mysqld &&\
    chown -R mysql:mysql /var/run/mysqld &&\
    chown -R mysql:mysql /var/lib/mysql
RUN rm -f /etc/mysql/my.cnf
COPY ./tools/entrypoint.sh /tmp/entrypoint.sh
RUN chmod +x /tmp/entrypoint.sh

ENTRYPOINT ["sh", "/tmp/entrypoint.sh"]
