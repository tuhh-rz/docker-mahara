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

ln -s /etc/apache2/sites-available/default.conf /etc/apache2/sites-enabled/

rsync -rc /tmp/mahara/htdocs/* "/var/www/html"
chown -Rf www-data.www-data "/var/www/html"

chmod +x /etc/apache2/foreground.sh

[ ! -d ${APACHE_RUN_DIR:-/var/run/apache2} ] && mkdir -p ${APACHE_RUN_DIR:-/var/run/apache2}
[ ! -d ${APACHE_LOCK_DIR:-/var/lock/apache2} ] && mkdir -p ${APACHE_LOCK_DIR:-/var/lock/apache2} && chown ${APACHE_RUN_USER:-www-data} ${APACHE_LOCK_DIR:-/var/lock/apache2}

/usr/bin/supervisord -n -c /etc/supervisord.conf
