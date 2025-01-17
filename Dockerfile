FROM caddy:2.5.2-alpine as caddyimage
FROM debian:stable-slim

# Identify the maintainer of an image
LABEL maintainer="contact@openchia.io"

# Update the image to the latest packages
RUN apt-get update && apt-get upgrade -y

RUN apt-get install python3-virtualenv libpq-dev git vim procps net-tools iputils-ping cron -y

EXPOSE 8000
EXPOSE 8001

WORKDIR /root

COPY ./requirements.txt /root
RUN virtualenv -p python3 venv
RUN ./venv/bin/pip install -r requirements.txt

COPY ./openchiaapi /root/api

COPY ./docker/start.sh /root/

COPY ./caddy/Caddyfile /etc/
COPY --from=caddyimage /usr/bin/caddy /usr/bin/caddy

CMD ["bash", "/root/start.sh"]
