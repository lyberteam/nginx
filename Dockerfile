FROM debian:jessie

RUN apt-get update && apt-get install -y \
        nginx \
        vim

COPY nginx.conf /etc/nginx/
COPY symfony.conf /etc/nginx/sites-available/

# We can avoid the next line and put symfony.conf in sites-enabled directly (in prew line)
RUN ln -s /etc/nginx/sites-available/symfony.conf /etc/nginx/sites-enabled/symfony

RUN rm /etc/nginx/sites-enabled/default

# We can avoid this line if in symfony.conf we will redirect proxy_pass directly on the php-fpm socket
RUN echo "upstream php-upstream { server php:9000; }" > /etc/nginx/conf.d/upstream.conf

RUN usermod -u 1000 www-data

# This volume for logs saving
VOLUME "/var/log/nginx"

CMD ["nginx"]

# 443 - port only if we will use https

EXPOSE 80 443