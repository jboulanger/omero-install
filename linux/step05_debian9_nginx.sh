#!/bin/bash

OMEROVER=${OMEROVER:-latest}
VIRTUALENV=${VIRTUALENV:-/home/omero/omeroenv}

#start-nginx-install
apt-get -y install nginx gunicorn
#end-nginx-install

#start-copy
cp setup_omero_nginx.sh ~omero
#end-copy

cd ~omero

# set up as the omero user.
su - omero -c "VIRTUALENV=$VIRTUALENV bash -x setup_omero_nginx.sh nginx"

#start-nginx-admin
mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.disabled
cp OMERO.server/nginx.conf.tmp /etc/nginx/conf.d/omero-web.conf

service nginx start
#end-nginx-admin
