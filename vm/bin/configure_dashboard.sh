#!/usr/bin/env bash

if [ -f /usr/local/src/dashboard/.env.prod ]; then
  rm /usr/local/src/dashboard/.env.prod
fi

if [ "$1" != "shared_folders" ]; then
echo "URL_SITES_EXTERNAL=http://$2:8080
URL_FILES_EXTERNAL=http://$2:8084
URL_DBADMIN_EXTERNAL=http://$2:8082
URL_MAIL_EXTERNAL=http://$2:8025
URL_CMD_EXTERNAL=http://$2:8022
URL_LOGS_EXTERNAL=http://$2:8083
URL_IDE_EXTERNAL=http://$2:8011
URL_MONIT_EXTERNAL=http://$2:2812" > /usr/local/src/dashboard/.env.prod
fi