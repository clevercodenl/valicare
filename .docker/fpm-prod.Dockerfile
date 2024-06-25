# syntax=docker/dockerfile:experimental

# Use official composer library to move the composer binary to the PHP container
FROM composer:2 AS composer

FROM php:8.2-fpm-buster

# Copy the composer binary to the container
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apt-get update \
    && apt-get install -y \
    libicu-dev \
    libzip-dev \
    libxml2-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    locales \
    locales-all \
    unzip \
    git \
    libmagickwand-dev \
    && rm -rf /var/lib/apt/lists/* \
    && pecl install imagick -y \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
    -j$(nproc) gd \
    intl \
    zip \
    pdo_mysql \
    pcntl \
    opcache \
    && docker-php-ext-enable gd imagick \
    && rm -rf /var/lib/apt/lists/* \
    && cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

WORKDIR /app

COPY . .
COPY ./.docker/www-prod.conf /usr/local/etc/php-fpm.d/www.conf

ARG phpmemlimit=512M
RUN sed -i "s/memory_limit = .*/memory_limit = '${phpmemlimit}'/" /usr/local/etc/php/php.ini \
    && sed -i "s/;chdir = \/var\/www/chdir = \/app\/public/" /usr/local/etc/php-fpm.d/www.conf \
    && chmod +x .docker/*.sh

RUN composer install --prefer-dist --no-ansi --no-progress --no-interaction --optimize-autoloader --no-dev --no-cache \
    && chown -R www-data:www-data /app

CMD [ "sh", "./.docker/start-server.sh" ]
