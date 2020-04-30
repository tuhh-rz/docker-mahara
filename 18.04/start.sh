#!/bin/bash

sed -i '/SSLCertificateFile/d' /etc/apache2/sites-available/default-ssl.conf
sed -i '/SSLCertificateKeyFile/d' /etc/apache2/sites-available/default-ssl.conf
sed -i '/SSLCertificateChainFile/d' /etc/apache2/sites-available/default-ssl.conf

sed -i 's/SSLEngine.*/SSLEngine on\nSSLCertificateFile \/etc\/apache2\/ssl\/cert.pem\nSSLCertificateKeyFile \/etc\/apache2\/ssl\/private_key.pem\nSSLCertificateChainFile \/etc\/apache2\/ssl\/cert-chain.pem/' /etc/apache2/sites-available/default-ssl.conf

ln -s /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/

/usr/sbin/a2enmod ssl

mkdir -p /var/local/mahara

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

cp -r /tmp/langpacks/* /var/local/mahara/langpacks/

rm /var/www/html/config.php
cp /var/www/html/config-dist.php /var/www/html/config.php


find /var/local/mahara ! -user www-data -exec chown www-data: {} +
find /var/www/html ! -user www-data -exec chown www-data: {} +

#$cfg->dbtype   = 'postgres';
#$cfg->dbhost   = 'localhost';
#$cfg->dbport   = null; // Change if you are using a non-standard port number for your database
#$cfg->dbname   = '';
#$cfg->dbuser   = '';
#$cfg->dbpass   = '';
sed -i 's/.*\$cfg->dbtype.*/\$cfg->dbtype = \x27'${DB_TYPE}'\x27;/g' /var/www/html/config.php
sed -i 's/.*\$cfg->dbhost.*/\$cfg->dbhost = \x27'${DB_HOST}'\x27;/g' /var/www/html/config.php
sed -i 's/.*\$cfg->dbport.*/\$cfg->dbport = '${DB_PORT}';/g' /var/www/html/config.php
sed -i 's/.*\$cfg->dbname.*/\$cfg->dbname = \x27'${DB_NAME}'\x27;/g' /var/www/html/config.php
sed -i 's/.*\$cfg->dbuser.*/\$cfg->dbuser = \x27'${DB_USER}'\x27;/g' /var/www/html/config.php
sed -i 's/.*\$cfg->dbpass.*/\$cfg->dbpass = \x27'${DB_PASS}'\x27;/g' /var/www/html/config.php
sed -i 's/.*\$cfg->dataroot.*/\$cfg->dataroot = \x27'${DATA_ROOT//\//\\/}'\x27;/g' /var/www/html/config.php
sed -i 's/.*\$cfg->wwwroot.*/\$cfg->wwwroot = \x27'${WWW_ROOT//\//\\/}'\x27;/g' /var/www/html/config.php
sed -i 's/.*\$cfg->urlsecret.*/\$cfg->urlsecret = \x27'${URL_SECRET//\//\\/}'\x27;/g' /var/www/html/config.php
sed -i 's/.*\$cfg->passwordsaltmain.*/\$cfg->passwordsaltmain = \x27'${PASSWORD_SALT_MAIN}'\x27;/g' /var/www/html/config.php

chmod +x /etc/apache2/foreground.sh

[ ! -d "${APACHE_RUN_DIR:-/var/run/apache2}" ] && mkdir -p "${APACHE_RUN_DIR:-/var/run/apache2}"
[ ! -d "${APACHE_LOCK_DIR:-/var/lock/apache2}" ] && mkdir -p "${APACHE_LOCK_DIR:-/var/lock/apache2}" && chown "${APACHE_RUN_USER:-www-data}" "${APACHE_LOCK_DIR:-/var/lock/apache2}"

/usr/sbin/a2enmod rewrite

su -s /bin/sh -c 'php /var/www/html/admin/cli/upgrade.php' www-data

exec /usr/bin/supervisord -n -c /etc/supervisord.conf
