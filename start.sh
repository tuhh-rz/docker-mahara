#!/bin/bash

chown -Rf www-data.www-data /var/www/html/

#register_globals off
#magic_quotes_runtime off
#magic_quotes_sybase off
#magic_quotes_gpc off
#log_errors on
#allow_call_time_pass_reference off
sed -i 's/upload_max_filesize.*/upload_max_filesize = 100M/g' /etc/php/7.0/apache2/php.ini
sed -i 's/post_max_size.*/post_max_size = 100M/g' /etc/php/7.0/apache2/php.ini
sed -i 's/register_globals.*/register_globals off/g' /etc/php/7.0/apache2/php.ini
sed -i 's/magic_quotes_runtime.*/magic_quotes_runtime off/g' /etc/php/7.0/apache2/php.ini
sed -i 's/magic_quotes_sybase.*/magic_quotes_sybase off/g' /etc/php/7.0/apache2/php.ini
sed -i 's/magic_quotes_gpc.*/magic_quotes_gpc = off/g' /etc/php/7.0/apache2/php.ini
sed -i 's/log_errors.*/log_errors on/g' /etc/php/7.0/apache2/php.ini
sed -i 's/allow_call_time_pass_reference.*/allow_call_time_pass_reference off/g' /etc/php/7.0/apache2/php.ini

ln -sf /etc/apache2/sites-available/default.conf /etc/apache2/sites-enabled/

rsync -rc /tmp/mahara/htdocs/* "/var/www/html"
chown -Rf www-data.www-data "/var/www/html"

rm /var/www/html/config.php
cp /var/www/html/config-dist.php /var/www/html/config.php

#$cfg->dbtype   = 'postgres';
#$cfg->dbhost   = 'localhost';
#$cfg->dbport   = null; // Change if you are using a non-standard port number for your database
#$cfg->dbname   = '';
#$cfg->dbuser   = '';
#$cfg->dbpass   = '';
sed -i 's/\$cfg->dbtype.*/\$cfg->dbtype = \x27'${DB_TYPE}'\x27/g' /var/www/html/config.php
sed -i 's/\$cfg->dbhost.*/\$cfg->dbhost = \x27'${DB_HOST}'\x27/g' /var/www/html/config.php
sed -i 's/\$cfg->dbport.*/\$cfg->dbport = \x27'${DB_PORT}'\x27/g' /var/www/html/config.php
sed -i 's/\$cfg->dbname.*/\$cfg->dbname = \x27'${DB_NAME}'\x27/g' /var/www/html/config.php
sed -i 's/\$cfg->dbuser.*/\$cfg->dbuser = \x27'${DB_USER}'\x27/g' /var/www/html/config.php
sed -i 's/\$cfg->dbpass.*/\$cfg->dbpass = \x27'${DB_PASS}'\x27/g' /var/www/html/config.php

chmod +x /etc/apache2/foreground.sh

[ ! -d ${APACHE_RUN_DIR:-/var/run/apache2} ] && mkdir -p ${APACHE_RUN_DIR:-/var/run/apache2}
[ ! -d ${APACHE_LOCK_DIR:-/var/lock/apache2} ] && mkdir -p ${APACHE_LOCK_DIR:-/var/lock/apache2} && chown ${APACHE_RUN_USER:-www-data} ${APACHE_LOCK_DIR:-/var/lock/apache2}

/usr/bin/supervisord -n -c /etc/supervisord.conf
