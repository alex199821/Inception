FROM alpine:3.16

RUN apk update && \
    apk add mariadb mariadb-client bash

COPY requirements/mariadb/tools/mariadb-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/mariadb-entrypoint.sh

ENTRYPOINT ["mariadb-entrypoint.sh"]