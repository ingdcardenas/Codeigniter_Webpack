FROM php:7.4-fpm-alpine
WORKDIR /var/www/html
RUN apk update && apk add curl icu-dev libxml2-dev
RUN apk add --no-cache pcre-dev $PHPIZE_DEPS
RUN pecl install redis \
    && docker-php-ext-enable redis.so
RUN docker-php-ext-install intl mysqli pdo pdo_mysql
RUN mkdir /usr/bin/composer && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
COPY codeigniter/scr /var/www/html
RUN cd /var/www/html && composer install --ignore-platform-req=ext-intl
CMD ["php-fpm"]
