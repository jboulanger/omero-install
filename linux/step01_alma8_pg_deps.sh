#!/bin/bash

PGVER=${PGVER:-pg11}
dnf -y module disable postgresql
dnf -y module enable postgresql:$(echo $PGVER | sed 's/pg//g')
dnf -y install postgresql-server
su - postgres -c "pg_ctl initdb"
sed -i.bak -re 's/^(host.*)ident/\1md5/' /var/lib/pgsql/data/pg_hba.conf
systemctl start postgresql
systemctl enable postgresql

