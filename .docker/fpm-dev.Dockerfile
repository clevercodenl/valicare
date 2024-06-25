# syntax=docker/dockerfile:experimental
FROM php:8.2-fpm-buster

RUN apt-get update \
    && apt-get install -y \
        libicu-dev \
        libzip-dev \
        libxml2-dev \
        unzip \
        libmagickwand-dev \
    && pecl install pcov imagick -y \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure \
        intl \
    && docker-php-ext-install \
        zip \
        pdo_mysql \
        pcntl \
    && docker-php-ext-enable \
        pcov \
        imagick \
    && apt-get remove --purge libicu-dev libzip-dev libxml2-dev -y \
    && cp /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini
