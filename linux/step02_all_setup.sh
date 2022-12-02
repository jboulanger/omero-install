#!/bin/bash

if [ -z "$(getent passwd omero-server)" ]; then
	#start-create-user
    useradd -mr omero-server
    # Give a password to the omero user
    # e.g. passwd omero-server
    #end-create-user
fi

# if the omero-server is a network user, it may not have a home folder
if [ ! -d /home/omero-server ]; then
    mkdir /home/omero-server
    chown -R omero-server /home/omero-server
    ID=$(id -u)
    echo "omero-server:x:$ID:" >> /etc/passwd
    echo "omero-server:x:$ID:$ID:Omero-server:/home/omero-server:/sbin/nologin" >> /etc/passwd
fi

chmod a+X ~omero-server

mkdir -p "$OMERO_DATA_DIR"
chown omero-server "$OMERO_DATA_DIR"
