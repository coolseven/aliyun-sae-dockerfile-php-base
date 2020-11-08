ARG PHP_VERSION=7.2.27-fpm-alpine3.11
ARG COMPOSER_VERSION=2.0.4

FROM composer:${COMPOSER_VERSION} as composer
FROM php:${PHP_VERSION}

COPY --from=composer /usr/bin/composer /usr/bin/composer

# https://github.com/mlocati/docker-php-extension-installer
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

ARG ALPINE_URL=mirrors.ustc.edu.cn
ARG INSTALL_XDEBUG=false

RUN sed -i "s:dl-cdn.alpinelinux.org:${ALPINE_URL}:g" /etc/apk/repositories \
    && apk add --verbose --no-cache \
       git \
       openssh \
       zip \
    && install-php-extensions \
        bcmath \
        pcntl \
        intl \
        mysqli \
        pdo_mysql \
        zip \
        opcache \
        gd \
        redis \
    && if [ ${INSTALL_XDEBUG} = true ]; then  \
         install-php-extensions xdebug \
         && docker-php-ext-enable xdebug \
       ;fi

ENV TZ Asia/Shanghai

RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

WORKDIR /app


