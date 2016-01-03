<p align="center">
  <a href="http://docker.io">
    <img height="81" width="341" src="http://upload.wikimedia.org/wikipedia/commons/7/79/Docker_(container_engine)_logo.png">
  </a>
</p>
-----
# docker-nginx-php7
A Nginx + PHP 7.0 (FPM) base container. Builds upon on the excellent [phusion/baseimage-docker](https://github.com/phusion/baseimage-docker) container. You can find the docker automated build [here](https://registry.hub.docker.com/u/ttaranto/docker-nginx-php7/).


### Timezone
The machine is configured to user America/Sao_Paulo timezone. The Nginx configuration is ready to run a [Laravel](https://laravel.com/) app.

### Services
All services are defined and managed using the phusion/baseimage methodology. Logs are output using syslog and can be accessed using ``docker logs {container}``.

* Nginx (lastest)
* PHP-FPM (7.0)
* Node.JS (lastest)
* XTERM environment support w/colors

### Default Settings
The container sets up a www root folder in the following location:

``/var/www/public``

As a final task a demo index.php is copied to this location.

### Web Root
The following folder is specified as the default root web folder:

``/var/www/public``

Note that the ``/var/www/public`` is the root folder for serving PHP files for your web server.

### Build Folder (within repo)
Contains nginx config files as well as php-fpm settings. Also include setup.sh file that offloads tasks from the Dockerfile to reduce layers.

### Databases
This image supports mysql.
