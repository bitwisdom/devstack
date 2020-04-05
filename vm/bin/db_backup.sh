#!/usr/bin/env bash

mysqldump -u root --password=root --add-drop-database --flush-privileges --all-databases > /userdata/dev/data/db_backup.sql

if [ -f /userdata/dev/data/db_backup.sql.gz ]; then
    rm -f /userdata/dev/data/db_backup.sql.gz
fi

gzip /userdata/dev/data/db_backup.sql
