#!/usr/bin/env bash

if [ -f /userdata/dev/data/db_backup.sql.gz ]; then
    gunzip -k /userdata/dev/data/db_backup.sql
    mysql -u root --password=root < /userdata/dev/data/db_backup.sql
    rm -f /userdata/dev/data/db_backup.sql
fi
