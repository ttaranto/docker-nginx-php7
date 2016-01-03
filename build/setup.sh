#!/usr/bin/env bash

##-------------------------------------------------------
# UPDATE CONFIG FILES
##-------------------------------------------------------

# set timezone machine to America/Sao_Paulo
cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

# set PHP7 timezone to America/Sao_Paulo
sed -i "s/;date.timezone =.*/date.timezone = America/Sao_Paulo/" /etc/php/7.0/fpm/php.ini
sed -i "s/;date.timezone =.*/date.timezone = America/Sao_Paulo/" /etc/php/7.0/cli/php.ini

# setup php7.0-fpm to not run as daemon (allow my_init to control)
sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.0/fpm/php-fpm.conf
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini

# setup permissions for php7.0-fpm
sed -i "/^;listen.mode = .*/alisten.mode = 0660" /etc/php/7.0/fpm/pool.d/www.conf
sed -i "/^listen.mode = .*/alisten.owner = www-data" /etc/php/7.0/fpm/pool.d/www.conf
sed -i "/^listen.mode = .*/alisten.group = www-data" /etc/php/7.0/fpm/pool.d/www.conf

# create run directories
mkdir -p /var/run/php
mkdir -p /var/run/php7.0-fpm && chown -R www-data:www-data /var/run/php7.0-fpm
mkdir -p /var/log/php7.0-fpm && chown -R www-data:www-data /var/log/php7.0-fpm