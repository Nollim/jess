FROM php:7.1-fpm

RUN apt-get update --fix-missing && apt-get install -y \
    zlib1g-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    mariadb-client \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install gd mbstring pdo pdo_mysql zip opcache mysqli

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN pecl install xdebug-2.5.5 && docker-php-ext-enable xdebug
# TODO : Remove next line as it's already enabled by docker-php-ext-enable xdebug
#RUN echo 'zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20160303/xdebug.so' >> /usr/local/etc/php/conf.d/xdebug.ini
RUN echo 'xdebug.remote_port=9000' >> /usr/local/etc/php/conf.d/xdebug.ini
RUN echo 'xdebug.remote_enable=1' >> /usr/local/etc/php/conf.d/xdebug.ini
RUN echo 'xdebug.remote_connect_back=1' >> /usr/local/etc/php/conf.d/xdebug.ini

RUN useradd -G www-data user

# Modify default user to avoid conflicts with local user
COPY config/docker_jh/dockerfiles/php/zz-bdt.conf /usr/local/etc/php-fpm.d/zz-bdt.conf

COPY config/docker_jh/dockerfiles/php/memory-limit-php.ini /usr/local/etc/php/conf.d/memory-limit-php.ini
COPY config/docker_jh/dockerfiles/php/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

RUN touch /var/log/error.log
RUN chown user:www-data /var/log/error.log