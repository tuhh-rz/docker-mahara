#!/bin/bash

chown -Rf www-data.www-data /var/www/html/

#register_globals off
#magic_quotes_runtime off
#magic_quotes_sybase off
#magic_quotes_gpc off
#log_errors on
#allow_call_time_pass_reference off
sed -i 's/upload_max_filesize.*/upload_max_filesize = 100M/g' /etc/php/7.0/fpm/php.ini
sed -i 's/post_max_size.*/post_max_size = 100M/g' /etc/php/7.0/fpm/php.ini
sed -i 's/register_globals.*/register_globals off/g' /etc/php/7.0/fpm/php.ini
sed -i 's/magic_quotes_runtime.*/magic_quotes_runtime off/g' /etc/php/7.0/fpm/php.ini
sed -i 's/magic_quotes_sybase.*/magic_quotes_sybase off/g' /etc/php/7.0/fpm/php.ini
sed -i 's/magic_quotes_gpc.*/magic_quotes_gpc = off/g' /etc/php/7.0/fpm/php.ini
sed -i 's/log_errors.*/log_errors on/g' /etc/php/7.0/fpm/php.ini
sed -i 's/allow_call_time_pass_reference.*/allow_call_time_pass_reference off/g' /etc/php/7.0/fpm/php.ini



#sed -i 's/<\/VirtualHost>/<Location \/Shibboleth.sso>\nSetHandler shib\nAuthType None\nRequire all granted\n<\/Location>\n<Directory  \/var\/www\/html\/moodle\/auth\/shibboleth\/index.php>\nAuthType shibboleth\nShibRequireSession On\nrequire valid-user\n<\/Directory>\n<\/VirtualHost>/' /etc/apache2/sites-available/default-ssl.conf

sed -i 's/<\/VirtualHost>/<Directory \/var\/www\/html>\nAllowOverride ALL\n<\/Directory>\n<\/VirtualHost>/' /etc/apache2/sites-available/000-default.conf

rsync -rc /tmp/mahara/* "/var/www/html"
chown -Rf www-data.www-data "/var/www/html"

chmod +x /etc/apache2/foreground.sh

/usr/bin/supervisord -n -c /etc/supervisord.conf
