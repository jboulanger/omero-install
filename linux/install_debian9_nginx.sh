#!/bin/bash

set -e -u -x

OMEROVER=${OMEROVER:-latest}
PGVER=${PGVER:-pg10}
ICEVER=${ICEVER:-ice36}

source settings.env
source settings-web.env

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

if [[ "$PGVER" =~ ^(pg94|pg95|pg96|pg10)$ ]]; then
	bash -eux step03_all_postgres.sh
fi
cp step01_debian9_ice_venv.sh settings.env settings-web.env step04_omero_patch_openssl.sh step04_all_omero.sh setup_omero_db.sh ~omero

# Create a virtual env to install Ice Python binding as the omero user
su - omero -c "VIRTUALENV=$VIRTUALENV bash -eux step01_debian9_ice_venv.sh"

su - omero -c "OMEROVER=$OMEROVER ICEVER=$ICEVER VIRTUALENV=$VIRTUALENV bash -eux step04_all_omero.sh"
su - omero -c "bash -eux step04_omero_patch_openssl.sh"
su - omero -c "bash setup_omero_db.sh"

OMEROVER=$OMEROVER bash -eux step05_debian9_nginx.sh


if [ "$WEBSESSION" = true ]; then
	bash -eux step05_2_websessionconfig.sh
fi

#If you don't want to use the init.d scripts you can start OMERO manually:
#su - omero -c "source $VIRTUALENV/bin/activate;OMERODIR=/home/omero/OMERO.server omero admin start"
#su - omero -c "source $VIRTUALENV/bin/activate;OMERODIR=/home/omero/OMERO.server omero web start"

bash -eux step06_ubuntu_daemon.sh

bash -eux step07_all_perms.sh

bash -eux step08_all_cron.sh

#service omero start
#service omero-web start
