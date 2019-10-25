FROM alpine:3.8
MAINTAINER Gabriel Ionescu <gabi.ionescu+docker@protonmail.com>

ENV MYSQL_ROOT_PASSWORD "password" \
    MYSQL_USER "user" \
    MYSQL_PASSWORD "password" \
    MYSQL_DATABASE "user_db"

RUN apk add --no-cache \
    mariadb \
 \
 && rm -rf \
    /tmp/* \
    /var/tmp/*

COPY install/run.sh /app/run.sh

WORKDIR /app

EXPOSE 3306

# LAUNCH
CMD ["ash", "run.sh"]