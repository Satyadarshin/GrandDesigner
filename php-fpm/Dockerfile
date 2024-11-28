# Dockerfile for PHP FPM
# @see https://hub.docker.com/_/php/

# Use the official PHP 8.1 FPM image
FROM php:8.1-fpm

# Get args from docker-compose.yml
ARG SMTP_USER
ARG SMTP_PASSWORD

# Update Debian packages
RUN apt-get update && apt-get dist-upgrade -y

# Use reccommended PHP settings for dev environment
RUN ln -s "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"


#
# Install PHP extensions required to match the server environment
#
# You may need to install additional packages or dependencies depending on the extension
# For example, if installing the "pdo_mysql" extension, you may need to install the "libpq-dev" package
# RUN apt-get install -y libpq-dev \
#     && docker-php-ext-install pdo pdo_mysql
#
# To troubleshoot this process, open a shell as root in the container, by running: docker compose exec -ti --user root php-fpm bash
#

# WordPress uses mysqli rather than PDO
RUN docker-php-ext-install mysqli

# Install the PHP GD extension and its dependencies
# @see https://www.php.net/manual/en/image.installation.php
RUN apt-get install -y \
		libfreetype-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
        libavif-dev \
        libwebp-dev \
	&& docker-php-ext-configure gd --with-freetype --with-avif --with-jpeg --with-webp \
	&& docker-php-ext-install -j$(nproc) gd

RUN apt-get install -y libicu-dev \
    && docker-php-ext-install intl

RUN apt-get install -y libxml2-dev \
    && docker-php-ext-install soap

RUN apt-get install -y libtidy-dev \
    && docker-php-ext-install tidy

RUN apt-get install -y libxslt1-dev \
    && docker-php-ext-install xsl

RUN apt-get install -y libzip-dev \
    && docker-php-ext-install zip

RUN docker-php-ext-install \
    calendar \
    exif \
    # ffi \ requires package libffi-dev
    gettext \
    # imap \ do we want the dev site to send emails?
    opcache \
    pdo_mysql \
    # pcntl \
    # pspell \
    shmop \
    sockets
    # sysvmsg \
    # sysvsem \
    # sysvshm \
    # xmlrpc \

# RUN install-php-extensions @composer

# @see https://www.codeproject.com/Articles/5258262/Replacing-SSMTP-with-MSMTP-in-Docker
# @see https://kitson-consulting.co.uk/blog/how-set-minimal-server-monit-and-email-alerts-using-msmtp
# Install the msmtp package to act as email client, and msmtp-mta package in order to get the server to use it for
# calls to sendmail.
# Optionally installing mailutils and mutt so we can use the mail commands.
# Optionally installing cron so can leave the container running.
# RUN apt-get install -y ca-certificates msmtp msmtp-mta mailutils mutt cron
RUN apt-get install -y ca-certificates msmtp msmtp-mta cron
COPY msmtprc /etc/msmtprc
RUN chown root:1000 /etc/msmtprc
RUN chmod 0640 /etc/msmtprc

# Set up logs for debugging
# RUN touch /var/log/msmtp.log
# RUN chown root:1000 /var/log/msmtp.log
# RUN chmod 0660 /var/log/msmtp.log

# Set up logs for debugging
# RUN touch /var/log/mail.log
# RUN chown root:1000 /var/log/mail.log
# RUN chmod 0660 /var/log/mail.log

# Use docker args to replace placeholders for username and password in 
RUN sed -i \ 
    -e "s/SMTP_USER/$SMTP_USER/g" \
    /etc/msmtprc
RUN sed -i \ 
    -e "s/SMTP_PASSWORD/$SMTP_PASSWORD/g" \
    /etc/msmtprc

COPY custom-php.ini /usr/local/etc/php/conf.d/
RUN sed -i \ 
    -e "s/SMTP_USER/$SMTP_USER/g" \
    /usr/local/etc/php/conf.d/custom-php.ini

