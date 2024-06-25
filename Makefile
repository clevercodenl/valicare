# Launch PHP CLI
php:
	docker-compose -f .docker/compose.tools.yml run --rm valicare-php-cli /bin/bash

# Run PHP Code Standards Fixer
cs:
	docker-compose -f .docker/compose.tools.yml run --rm valicare-php-cli vendor/bin/php-cs-fixer fix --allow-risky=yes --diff --verbose --show-progress=dots

# Run PHPStan
stan:
	docker-compose -f .docker/compose.tools.yml run --rm valicare-php-cli vendor/bin/phpstan --memory-limit=2G analyze

cs-stan:
	make cs stan

# Install PHP dependencies
init-dependencies:
	docker-compose -f .docker/compose.tools.yml run valicare-php-cli composer install

# Start Docker containers
up:
	docker-compose -f .docker/compose.dev.yml up -d --pull=never

# Stop Docker containers
down:
	docker-compose -f .docker/compose.dev.yml down

# Clear route cache
clear-routes:
	 docker-compose -f .docker/compose.tools.yml run --rm valicare-php-cli php artisan route:clear

# Run migrations
migrate:
	docker-compose -f .docker/compose.tools.yml run --rm valicare-php-cli php artisan migrate

# List routes
list-routes:
	docker-compose -f .docker/compose.tools.yml run --rm valicare-php-cli php artisan route:list

# Clear views
clear-views:
	docker-compose -f .docker/compose.tools.yml run --rm valicare-php-cli php artisan view:clear

# Clear cache
clear-cache:
	docker-compose -f .docker/compose.tools.yml run --rm valicare-php-cli php artisan cache:clear

# Horizon
start-queue:
	docker-compose -f .docker/compose.tools.yml run --rm valicare-php-cli php artisan queue:work

# Generate app key
key-generate:
	docker-compose -f .docker/compose.tools.yml run --rm valicare-php-cli php artisan key:generate

# Run php unit
test:
	docker-compose -f .docker/compose.tools.yml run --rm valicare-php-cli php artisan test

# Wipe database
wipe-db:
	docker-compose -f .docker/compose.tools.yml run --rm valicare-php-cli php artisan db:wipe

reset-log:
	rm -f storage/logs/laravel.log && touch storage/logs/laravel.log && chmod 777 storage/logs/laravel.log
