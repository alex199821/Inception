#!/bin/bash

set -e

: "${DB_NAME:?Missing DB_NAME}"
: "${DB_USER:?Missing DB_USER}"
: "${DB_PASS:?Missing DB_PASS}"

if [ ! -e /etc/.initialrun ]; then
cat << EOF >> /etc/my.cnf.d/mariadb-server.cnf
[mysqld]
bind-address=0.0.0.0
skip-networking=0
EOF
    touch /etc/.initialrun
fi

if [ ! -e /var/lib/mysql/.firstmount ]; then
    mysql_install_db --datadir=/var/lib/mysql --skip-test-db --user=mysql --group=mysql \
        --auth-root-authentication-method=socket >/dev/null 2>/dev/null

    mysqld_safe

    cat << EOF | mysql --protocol=socket -u root
-- Create application database and user first
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'%';

-- Set root password for localhost
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_PASS';

-- Remove insecure remote root access
DELETE FROM mysql.user WHERE User='root' AND Host='%';

FLUSH PRIVILEGES;
EOF

    # Shutdown using the new password
    mysqladmin --user=root --password="$DB_PASS" shutdown

    touch /var/lib/mysql/.firstmount
fi

exec mysqld_safe