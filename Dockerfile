FROM ubuntu:16.04 as builder

RUN apt-get update && apt-get upgrade -y && \
  apt-get install -y language-pack-ja wget build-essential tcl-dev \
  gettext libjson-perl libsqlite3-dev liblocale-po-perl rsync

RUN cd /tmp && \
  wget --trust-server-names http://repository.timesys.com/buildsources/l/libcgic/libcgic-205/cgic205.tar.gz && \
  tar zxf cgic205.tar.gz && \
  cd cgic205 && \
  make && \
  make install && \
  cd .. && \
  wget --trust-server-names https://ja.osdn.net/dl/starbug1/starbug1-1.6.01.tar.gz && \
  tar zxf starbug1-1.6.01.tar.gz && \
  cd starbug1-1.6.01 && \
  # bugfix. sql statement
  sed -i -e 's/m\.m\./m\./' db_project.c && \
  make INITIAL_LOCALE=ja_JP webapp


FROM debian:sid-slim

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

RUN apt-get update && apt-get upgrade -y && \
  apt-get install -y locales apache2 \
  gettext libjson-perl liblocale-po-perl && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

RUN sed -i -E 's/# (ja_JP.UTF-8)/\1/' /etc/locale.gen && \
  locale-gen &&\
  update-locale LANG=ja_JP.UTF-8

#RUN apt-get update && apt-get upgrade -y && \
#  apt-get install -y language-pack-ja apache2 \
#  gettext libjson-perl liblocale-po-perl && \
#  apt-get clean && rm -rf /var/lib/apt/lists/*
#
COPY --from=builder /tmp/starbug1-1.6.01/dist/starbug1/ /var/www/html/
RUN chown -R www-data:www-data /var/www/html

RUN sed -i -e 's/Options Indexes FollowSymLinks/Options Indexes FollowSymLinks ExecCGI\n\tDirectoryIndex index.cgi/g' /etc/apache2/apache2.conf
RUN sed -i -e 's/#AddHandler cgi-script .cgi/AddHandler cgi-script .cgi/g' /etc/apache2/mods-available/mime.conf
RUN a2enmod cgid

EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
