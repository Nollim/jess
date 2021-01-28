FROM httpd:2.4

COPY config/docker_jh/dockerfiles/httpd/httpd-vhosts.conf /usr/local/apache2/conf/extra/httpd-vhosts.conf
COPY config/docker_jh/dockerfiles/httpd/httpd.conf /usr/local/apache2/conf/httpd.conf

RUN useradd -G www-data user