FROM php:apache-buster
LABEL maintainer="LilDrunkenSmurf <jirving@lildrunkensmurf.com>"

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y upgrade \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install apt-utils \
        libcurl4-openssl-dev \
        libpq-dev \
        postgresql-client \
        apache2 \
        wget \
        curl \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install mysqli \
    pgsql

EXPOSE 80/tcp

# Download SMF
RUN mkdir -p /var/www/html \
    && cd /var/www/html \
    && wget "https://download.simplemachines.org/index.php/smf_2-0-17_install.tar.gz" \
    && tar zxf smf_2-0-17_install.tar.gz

# Set the permissions SMF wants. They say 777 suggested!
RUN chmod 777 /var/www/html/attachments \
    /var/www/html/avatars \
    /var/www/html/cache \
    /var/www/html/Packages \
    /var/www/html/Packages/installed.list \
    /var/www/html/Smileys \
    /var/www/html/Themes \
    /var/www/html/agreement.txt \
    /var/www/html/Settings.php \
    /var/www/html/Settings_bak.php

# Setup the Apache config file to serve this application

# Serve the application, so the user could run the install manually
RUN mkdir -p /run/apache2
CMD ["/usr/sbin/apachectl","-DFOREGROUND"]
