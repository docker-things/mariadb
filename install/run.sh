#!/bin/ash

if [ ! -d "/run/mysqld" ]; then
    mkdir -p /run/mysqld
    chown -R mysql:mysql /run/mysqld
fi

if [ ! -f /var/lib/mysql/first_launch ]; then
    echo " > Creating MySQL data directory"

    mkdir -p /var/lib/mysql/data
    chown -R mysql:mysql /var/lib/mysql
    cd /var/lib/mysql

    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    tfile=`mktemp`
    if [ ! -f "$tfile" ]; then
        return 1
    fi

    echo ' > Set mysql root password'
    cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
UPDATE user SET password=PASSWORD("$MYSQL_ROOT_PASSWORD") WHERE user='root';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
UPDATE user SET password=PASSWORD("") WHERE user='root' AND host='localhost';
CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;
GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
EOF

    /usr/bin/mysql_embedded < $tfile
    chown -R mysql:mysql /var/lib/mysql

    rm -f $tfile

    touch /var/lib/mysql/first_launch
fi

/usr/bin/mysqld --user=mysql --console
