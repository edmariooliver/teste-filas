FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

# RUN apt-get update \
#     && apt-get install -y \
#     git \
#     curl \
#     wget \
#     vim \
#     unzip \
#     && apt-get clean

RUN apt-get update \
    && apt-get install -y \
    php-dev \
    php-pear \
    php-curl \
    php-xml \
    php-mbstring \
    php-zip \
    php-gd \
    php-mysql \ 
    && pecl install swoole \
    && echo "extension=swoole.so" > /etc/php/$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')/mods-available/swoole.ini \
    && ln -s /etc/php/$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')/mods-available/swoole.ini etc/php/$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')/cli/conf.d/20-swoole.ini \
    && apt-get clean

RUN php -v \
    && php -m \
    && php --ri swoole 

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY . /opt/www/

WORKDIR /opt/www

RUN composer install

EXPOSE 8000

ENTRYPOINT [ "php", "artisan", "octane:start"]