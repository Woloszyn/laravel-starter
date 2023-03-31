FROM php:8.1-fpm-alpine

RUN apk add --update linux-headers
RUN apk update && apk add --no-cache \
    bash \
    libzip-dev \
    zip \
    unzip \
    curl \
    libpng-dev \
    libxml2-dev \
    oniguruma-dev \
    $PHPIZE_DEPS \
    && docker-php-ext-install pdo_mysql mysqli mbstring exif pcntl bcmath gd soap \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

COPY . .

RUN composer install --prefer-dist --no-interaction

RUN chown -R www-data:www-data storage bootstrap/cache

CMD php artisan serve --host=0.0.0.0 --port=8000