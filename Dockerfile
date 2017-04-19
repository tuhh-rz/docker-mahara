FROM docker.rz.tu-harburg.de:5000/docker/apache2:latest

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y upgrade

RUN apt-get -y install \
    git
    
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
    php \
    php-curl \
    php-gd \
    php-json \
    php-ldap \
    php-libxml \
    php-mbstring \
    php-mcrypt \
    php-mysql \
    php-xml \
    php-bz2 \
    php-imagick \
    php-xmlrpc \
    php-memcache \
    libphp-adodb \
    php-pspell
    
RUN git clone https://git.mahara.org/mahara/mahara.git /tmp/mahara
RUN cd /tmp/mahara; git checkout 17.04_STABLE