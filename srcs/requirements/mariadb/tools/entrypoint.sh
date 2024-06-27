#!/bin/sh

run_command() {
    eval "$1"
}

echo "Starting MariaDB installation..."
run_command "service mariadb start"

# Read secrets from the Docker secrets files
DB_ROOT=$(cat /run/secrets/db_password)
DB_PASS=$(cat /run/secrets/db_user_password)
WP_PASS=$(cat /run/secrets/wp_user_password)

config="
[client-server]
# Port or socket location where to connect
port = 3306
socket = /run/mysqld/mysqld.sock

# Import all .cnf files from configuration directory
!includedir /etc/mysql/conf.d/
!includedir /etc/mysql/mariadb.conf.d/

[mysqld]
port = 3306
bind-address = 0.0.0.0
"
echo "$config" > /etc/mysql/my.cnf

if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    run_command "
    mysql_secure_installation << EOF
    $DB_ROOT
    y
    n
    y
    y
    y
    y
    EOF
    "
    echo "MySQL secure installation completed."
fi

echo "MariaDB Starting Setup."

run_command "
mariadb <<EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';
CREATE USER '$WP_USER'@'%' IDENTIFIED BY '$WP_PASS';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$DB_USER'@'%';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$WP_USER'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$DB_ROOT' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$DB_ROOT' WITH GRANT OPTION;
SELECT user, host FROM mysql.user;
FLUSH PRIVILEGES;
exit
EOF
"

echo "MariaDB setup completed."

echo "Stopping MariaDB..."
run_command "service mariadb stop"

echo "Starting MariaDB as a Server..."
run_command "exec mysqld --datadir=/var/lib/mysql"
