FROM alpine:3.21

ARG PHP_VERSION=82
ARG DB_NAME
ARG DB_USER
ARG DB_PASS

RUN apk update && \
    apk upgrade && \
    apk add --no-cache wget unzip curl && \
    for ext in fpm mysqli json curl dom exif fileinfo mbstring openssl xml zip redis; do \
        apk add --no-cache php${PHP_VERSION}-$ext; \
    done && \
    apk add --no-cache php${PHP_VERSION}
    
RUN conf="/etc/php${PHP_VERSION}/php-fpm.d/www.conf" && \
    sed -i 's|listen = 127.0.0.1:9000|listen = 9000|' "$conf" && \
    sed -i 's|;listen.owner = nobody|listen.owner = nobody|' "$conf" && \
    sed -i 's|;listen.group = nobody|listen.group = nobody|' "$conf" && \
    rm -rf /var/cache/apk/*

WORKDIR /var/www

RUN curl -LO https://wordpress.org/latest.zip && \
    unzip latest.zip && \
    mv wordpress/* . && \
    rm -rf wordpress latest.zip

COPY requirements/wordpress/conf/create_wordpress.sh /tmp/create_wordpress.sh
RUN sh /tmp/create_wordpress.sh && \
    rm /tmp/create_wordpress.sh && \
    chmod -R 0777 wp-content

CMD ["php-fpm82", "-F"]
