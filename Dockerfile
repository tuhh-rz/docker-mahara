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
    
RUN git clone https://git.mahara.org/mahara/mahara.git /tmp/mahara
RUN cd /tmp/mahara
RUN git checkout 17.04_STABLE