FROM ubuntu:16.04

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

#RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

#RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 5072E1F5 && \
#  gpg --export --armor 5072E1F5 | sudo apt-key add -
RUN apt-get update && apt-get upgrade -y && apt-get install -y apache2 wget build-essential tcl-dev gettext libjson-perl
#sqlite3-dev

RUN cd /tmp && \
  wget --trust-server-names http://repository.timesys.com/buildsources/l/libcgic/libcgic-205/cgic205.tar.gz && \
  tar zxf cgic205.tar.gz && \
  cd cgic205 && \
  make && \
  make install && \
  cd .. && \
  wget --trust-server-names http://www.sqlite.org/sqlite-3.5.4.tar.gz && \
  tar zxf sqlite-3.5.4.tar.gz && \
  mkdir bld && \
  cd bld && \
  ../sqlite-3.5.4/configure --disable-tcl && \
  make && \
  make install && \
  cd .. && \
  echo 'aaa'

RUN apt-get install -y liblocale-po-perl rsync
RUN  cd /tmp && wget --trust-server-names https://ja.osdn.net/dl/starbug1/starbug1-1.6.01.tar.gz && \
  tar zxf starbug1-1.6.01.tar.gz && \
  cd starbug1-1.6.01 && \
#  sed -i -e 's/wget/wget --trust-server-names/g' Makefile && \
#  sed -i -e 's@http://www.boutell.com/cgic/cgic205.tar.gz@http://repository.timesys.com/buildsources/l/libcgic/libcgic-205/cgic205.tar.gz@' Makefile && \
  make INITIAL_LOCALE=ja_JP webapp

RUN cp -r /tmp/starbug1-1.6.01/dist/starbug1/* /var/www/html
RUN chown -R www-data:www-data /var/www/html
RUN apt-get install -y vim

RUN sed -i -e 's/Options Indexes FollowSymLinks/Options Indexes FollowSymLinks ExecCGI\n\tDirectoryIndex index.cgi/g' /etc/apache2/apache2.conf
RUN sed -i -e 's/#AddHandler cgi-script .cgi/AddHandler cgi-script .cgi/g' /etc/apache2/mods-available/mime.conf
RUN a2enmod cgid

EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
