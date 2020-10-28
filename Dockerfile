ARG PHP_VERSION=7-fpm-alpine
ARG COMPOSER_VERSION=2.0.2

FROM composer:${COMPOSER_VERSION} as composer
FROM php:${PHP_VERSION}

COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

ARG ALPINE_URL=dl-cdn.alpinelinux.org
ARG INSTALL_XDEBUG=false

RUN sed -i "s:dl-cdn.alpinelinux.org:${ALPINE_URL}:g" /etc/apk/repositories \
    && apk add --no-cache \
       git \
       openssh \
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


ENV TZ ${TZ:-Asia/Shanghai}


