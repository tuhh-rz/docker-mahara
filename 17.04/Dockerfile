FROM docker.rz.tu-harburg.de:5000/docker/apache2:latest

ENV VERSION=17.04_STABLE

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y upgrade

RUN apt-get -y install \
    git \
    supervisor

# Mahara requires PHP version 5.4 or later. The "magic_quotes" and "register_globals"
# settings should be turned off (which is the default on modern PHP installations).
#
# The following PHP extensions are also required:
#
#
# curl
# gd (including Freetype support)
# json
# ldap
# libxml
# mbstring
# mcrypt
# mime_magic; or fileinfo
# pgsql; or mysqli; or mysql
# session
# SimpleXML
# bz2 (optional)
# imagick (optional)
# openssl and xmlrpc (optional; for networking support)
# memcache (optional; for SAML auth plugin)
# zlib (optional)
# adodb (optional; improves performance)
# enchant or pspell (optional; for TinyMCE spellcheck button)

RUN apt-get -y install \
    libapache2-mod-php \
    php \
    php-curl \
    php-gd \
    php-json \
    php-ldap \
    php-mbstring \
    php-mcrypt \
    php-mysql \
    php-xml \
    php-xmlrpc \
    php-bz2 \
    php-imagick \
    php-xmlrpc \
    php-memcache \
    libphp-adodb \
    php-pspell

RUN apt-get -y install \
    make \
    npm \
    nodejs-legacy \
    cron \
    wget
    
RUN npm install -g gulp

RUN git clone https://git.mahara.org/mahara/mahara.git /tmp/mahara
RUN cd /tmp/mahara; git checkout ${VERSION}; make css

RUN wget http://langpacks.mahara.org/de-${VERSION}.tar.gz --directory-prefix /tmp/mahara/langpacks
RUN tar xf /tmp/mahara/langpacks/de-18.04_STABLE.tar.gz -C /tmp/mahara/langpacks && rm /tmp/mahara/langpacks/de-18.04_STABLE.tar.gz

RUN rm /etc/apache2/sites-enabled/*

ADD ./conf/default.conf /etc/apache2/sites-available
ADD ./start.sh /start.sh
ADD ./foreground.sh /etc/apache2/foreground.sh
ADD ./conf/supervisord.conf /etc/supervisord.conf

RUN echo "* * * * * www-data /usr/bin/php /var/www/html/lib/cron.php" >> /etc/crontab

EXPOSE 80 443
CMD ["/bin/bash", "/start.sh"]
