#!/bin/bash

#start-recommended
cat > /etc/systemd/system/omero-server.service << "EOF"
[Unit]
Description=OMERO.server
After=postgresql
After=network
After=ypbind

[Service]
User=omero-server
WorkingDirectory=/opt/omero
Type=forking
Restart=no
RestartSec=10
# Allow up to 5 min for start/stop
TimeoutSec=300
Environment="PATH=/opt/omero/server/venv3/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin"
Environment="OMERODIR=/opt/omero/server/OMERO.server"
Environment="OMERO_DATA_DIR=/cephfs2/omero-server"
Environment="OMERO_TMPDIR=/tmp/"
ExecStart=/opt/omero/server/venv3/bin/omero admin start
ExecStop=/opt/omero/server/venv3/bin/omero admin stop
# If you want to enable in-place imports uncomment this:
UMask=0002

[Install]
WantedBy=multi-user.target
EOF


if [ ! "${container:-}" = docker ]; then
    systemctl daemon-reload
fi
systemctl enable omero-server
#end-recommended
