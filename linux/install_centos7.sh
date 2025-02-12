#!/bin/bash

set -e -u -x

OMEROVER=${OMEROVER:-latest}
PGVER=${PGVER:-pg11}
ICEVER=${ICEVER:-ice36}

. `dirname $0`/settings.env

bash -eux step01_centos7_init.sh

# install java
bash -eux step01_centos_java_deps.sh

bash -eux step01_centos7_deps.sh

# install ice
bash -eux step01_centos7_ice_deps.sh

# install Postgres
bash -eux step01_centos7_pg_deps.sh

bash -eux step02_all_setup.sh

if [[ "$PGVER" =~ ^(pg11|pg12|pg13|pg14)$ ]]; then
    bash -eux step03_all_postgres.sh
fi

bash -eux step01_centos7_ice_venv.sh


# Those steps are valid if an omero-server user exists
# This might not be the case when used in the context of devspace
if [ "$(getent passwd omero-server)" ]; then
    cp settings.env step04_all_omero.sh setup_omero_db.sh ~omero-server

    OMEROVER=$OMEROVER ICEVER=$ICEVER bash -eux step04_all_omero_install.sh

    su - omero-server -c " bash -eux step04_all_omero.sh"

    su - omero-server -c "bash setup_omero_db.sh"
fi


#If you don't want to use the systemd scripts you can start OMERO manually:
#su - omero-server -c ". /home/omero-server/settings.env omero admin start"

bash -eux setup_centos_selinux.sh

PGVER=$PGVER bash -eux step06_centos7_daemon.sh

#systemctl start omero.service
