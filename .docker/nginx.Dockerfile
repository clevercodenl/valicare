# syntax=docker/dockerfile:experimental

# Use the alpine image to create the smallest possible image
FROM nginx:mainline-alpine

# Copy the composer binary to the container
WORKDIR /var/www/html/public
COPY ./public .
COPY ./.docker/php.conf /etc/nginx/conf.d/default.conf
COPY ./.docker/nginx-prod.conf /etc/nginx/nginx.conf
