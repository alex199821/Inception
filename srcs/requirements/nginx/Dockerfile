FROM alpine:3.16
RUN	apk update && apk upgrade && apk add --no-cache nginx openssl
RUN mkdir -p /etc/ssl/private /etc/ssl/certs && \
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/nginx-selfsigned.key \
  -out /etc/ssl/certs/nginx-selfsigned.crt \
  -subj "/CN=auplisas"

EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]

