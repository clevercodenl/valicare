ARG version

# Use official composer library to move the composer binary to the PHP container
FROM composer:2 AS composer

# Use the alpine image to create the smallest possible image
FROM php:8.2.7-cli

# Copy the composer binary to the container
COPY --from=composer /usr/bin/composer /usr/bin/composer
# Set composer home directory
ENV COMPOSER_HOME=/.composer
ENV COMPOSER_ALLOW_SUPERUSER=1

RUN apt-get update \
    && apt-get install -y \
        libxml2-dev \
        libzip-dev \
        mariadb-client \
        wget \
        cmake \
        unzip \
        libmagickwand-dev \
    && pecl install pcov imagick -y \
    && apt-get autoremove -y \
    && apt-get clean \
    && docker-php-ext-configure \
        intl \
    && docker-php-ext-install \
        zip \
        pdo_mysql \
        pcntl \
    && docker-php-ext-enable pcov imagick

WORKDIR /app
