FROM mysql:5.6

COPY config/docker_jh/dockerfiles/mysql/zz-bdt.cnf /etc/mysql/conf.d/zz-bdt.cnf
COPY config/docker_jh/dockerfiles/mysql/import-db.sh /import-db.sh
RUN chmod +x /import-db.sh