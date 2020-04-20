FROM debian:buster-slim
LABEL maintainer "Dirk Winkel <it@polarwinkel.de>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    git \
    nginx \
    tar \
    curl \
    php7.3-fpm \
    php7.3-zip \
    php7.3-curl \
    php7.3-xml \
    php7.3-mysql \
    php7.3-gd \
    php7.3-intl \
    php7.3-mbstring \
    php7.3-xmlrpc \
    php7.3-soap \
    php7.3-ldap \
    sudo
#RUN docker-php-ext-install zip

COPY moodle/ /var/www/moodle/
RUN chown -R root:www-data /var/www/moodle
RUN chmod =770 /var/www/moodle

COPY default /etc/nginx/sites-enabled/default
COPY entryFirst.sh /
RUN chmod +x entryFirst.sh

RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN echo "#!/bin/sh\n" >> run.sh
RUN echo "./entryFirst.sh" >> run.sh
RUN echo "service php7.3-fpm start\n" >> /run.sh 
RUN echo "nginx\n" >> /run.sh && chmod +x /run.sh

EXPOSE 90

#CMD ["nginx", "-g", "daemon off;"] 
CMD ["./run.sh"]
