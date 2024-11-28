# Dockerfile for Apache
# httpd base image
FROM httpd:2.4

# Enable Apache modules to ensure proper functionality
# @see https://thriveread.com/docker-apache-httpd-with-php-fpm-and-mysql/
RUN sed -i \
    # Uncomment the configuration for mod_deflate to enable compression
    -e '/#LoadModule deflate_module/s/^#//g' \
    # Uncomment the configuration for mod_proxy to enable proxying capabilities
    -e '/#LoadModule proxy_module/s/^#//g' \
    # Uncomment the configuration for mod_proxy_fcgi to enable FastCGI proxy module
    -e '/#LoadModule proxy_fcgi_module/s/^#//g' \
    /usr/local/apache2/conf/httpd.conf

RUN sed -i \ 
    -e 's/^#\(LoadModule .*mod_rewrite.so\)/\1/' \
    /usr/local/apache2/conf/httpd.conf

# Copy the TLS certificate into the container
# @see https://letsencrypt.org/docs/certificates-for-localhost/
COPY ./localhost.crt /usr/local/apache2/conf/
COPY ./localhost.key /usr/local/apache2/conf/
    
# Enable Apache TLS modules
# @see https://hub.docker.com/_/httpd
COPY ./httpd-ssl.conf  /usr/local/apache2/conf/extra/
RUN sed -i \
    -e 's/^#\(Include .*httpd-ssl.conf\)/\1/' \
    -e 's/^#\(LoadModule .*mod_ssl.so\)/\1/' \
    -e 's/^#\(LoadModule .*mod_socache_shmcb.so\)/\1/' \
    /usr/local/apache2/conf/httpd.conf


# Copy the Apache virtual host configuration file to the container
# COPY ./adhi.vhost.conf /usr/local/apache2/conf/extra/adhi.vhost.conf
# RUN echo "Include /usr/local/apache2/conf/extra/adhi.vhost.conf" >> /usr/local/apache2/conf/httpd.conf
