# Dockerfile for wp-cli

FROM wordpress:cli

# ARG MARIADB_NAME
# ARG MARIADB_ROOT_PASSWORD
# ARG MARIADB_HOST

# # Switch to root to give permission to install packages
# USER root

# # Install dependencies for PHPUnit and the WP CLI script that sets up plugin unit tests
# # https://make.wordpress.org/cli/handbook/misc/plugin-unit-tests/
# # RUN apk update && apk add git phpunit php-xdebug subversion
# RUN apk update 
# RUN apk add composer git php-xdebug subversion
# RUN apk add php82-dom php82-pdo php82-tokenizer php82-xml php82-xmlwriter 

# # TODO PHP config - https://docs.phpunit.de/en/9.6/installation.html#recommended-php-configuration

# # Install PHPUnit
# RUN composer global require --dev phpunit/phpunit:"^9"
# RUN composer global require --dev yoast/phpunit-polyfills:"^2.0"
# RUN ln -s /var/www/html/wp-content/plugins/paypal-event-booking/vendor/bin/phpunit /usr/local/bin/phpunit

# # Copy shell script
# COPY ./install-wp-tests.sh /usr/local/bin/

# # Set up testing dependencies
# RUN bash /usr/local/bin/install-wp-tests.sh ${MARIADB_NAME}_test root ${MARIADB_ROOT_PASSWORD} ${MARIADB_HOST} latest true

# Switch back to the UID that matches the user in the PHP-FPM container
USER 1000:1000