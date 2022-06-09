#!/bin/sh
/usr/local/bin/docker-entrypoint.sh postgres & python3 /opt/api/app.py && fg