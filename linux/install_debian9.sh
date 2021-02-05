#!/bin/bash

set -e -u -x

OMEROVER=${OMEROVER:-latest}
PGVER=${PGVER:-pg11}
ICEVER=${ICEVER:-ice36}

. settings.env

bash -eux step01_ubuntu_init.sh

# install java
bash -eux step01_debian9_java_deps.sh

bash -eux step01_debian9_deps.sh

# install ice
bash -eux step01_debian9_ice_deps.sh

if [ "$ICEVER" = "ice36" ]; then
    cat omero-ice36.env >> /etc/profile
fi

# install Postgres
bash -eux step01_debian9_pg_deps.sh

bash -eux step02_all_setup.sh

if [[ "$PGVER" =~ ^(pg96|pg10|pg11|pg12)$ ]]; then
    bash -eux step03_all_postgres.sh
fi
cp settings.env step04_omero_patch_openssl.sh step04_all_omero.sh setup_omero_db.sh ~omero-server

bash -x step01_debian9_ice_venv.sh
bash -eux step04_all_omero_install.sh

su - omero-server -c "OMEROVER=$OMEROVER ICEVER=$ICEVER bash -x step04_all_omero.sh"
su - omero-server -c "bash -x step04_omero_patch_openssl.sh"
su - omero-server -c "bash setup_omero_db.sh"


#If you don't want to use the init.d scripts you can start OMERO manually:
#su - omero-server -c ". /home/omero-server/settings.env omero admin start"

bash -eux step06_ubuntu_daemon.sh

bash -eux step07_all_perms.sh

#service omero start
