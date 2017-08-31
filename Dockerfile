FROM phusion/baseimage
MAINTAINER Thiago Taranto <ttaranto@gmail.com>

# ensure UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# change resolv.conf
RUN echo 'nameserver 8.8.8.8' >> /etc/resolv.conf

# setup
ENV HOME /root
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

CMD ["/sbin/my_init"]

# nginx-php installation
RUN DEBIAN_FRONTEND="noninteractive" apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y upgrade
RUN DEBIAN_FRONTEND="noninteractive" apt-get update --fix-missing
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install php7.0
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install php7.0-fpm php7.0-common php7.0-cli php7.0-mysqlnd php7.0-mcrypt php7.0-curl php7.0-bcmath php7.0-mbstring php7.0-soap php7.0-xml php7.0-zip php7.0-json php7.0-imap php-xdebug php-pgsql

# install nginx (full)
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y nginx-full

# install latest version of nodejs
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y nodejs
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y npm
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y git

# install yarn
RUN DEBIAN_FRONTEND="noninteractive" curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN DEBIAN_FRONTEND="noninteractive" echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN DEBIAN_FRONTEND="noninteractive" apt-get update && apt-get install yarn

# install php composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# add build script (also set timezone to Americas/Sao_Paulo)
RUN mkdir -p /root/setup
ADD build/setup.sh /root/setup/setup.sh
RUN chmod +x /root/setup/setup.sh
RUN (cd /root/setup/; /root/setup/setup.sh)

# copy files from repo
ADD build/nginx.conf /etc/nginx/sites-available/default
ADD build/.bashrc /root/.bashrc

# disable services start
RUN update-rc.d -f apache2 remove
RUN update-rc.d -f nginx remove
RUN update-rc.d -f php7.0-fpm remove

# add startup scripts for nginx
ADD build/nginx.sh /etc/service/nginx/run
RUN chmod +x /etc/service/nginx/run

# add startup scripts for php7.0-fpm
ADD build/phpfpm.sh /etc/service/phpfpm/run
RUN chmod +x /etc/service/phpfpm/run

# set WWW public folder
RUN mkdir -p /var/www/public
ADD build/index.php /var/www/public/index.php

RUN chown -R www-data:www-data /var/www
RUN chmod 755 /var/www

# set terminal environment
ENV TERM=xterm

# port and settings
EXPOSE 80 9000

# cleanup apt and lists
RUN apt-get clean
RUN apt-get autoclean
