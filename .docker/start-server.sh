#!/usr/bin/env sh
set -e

php artisan config:cache

if [ "$IS_LARAVEL_WORKER" = "1" ]
then
  php artisan queue:work
elif [ "$IS_LARAVEL_SCHEDULER" = "1" ]
then
  php artisan schedule:work
else
  php artisan route:cache
  php artisan view:cache
  php-fpm
fi

