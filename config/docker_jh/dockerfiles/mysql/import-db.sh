#!/bin/bash

for f in /docker-entrypoint-initdb.d/*; do
  case "$f" in
    *.sql) echo "[Entrypoint] running $f"; mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} < $f && echo ;;
    *)     echo "[Entrypoint] ignoring $f" ;;
  esac
  echo
done
