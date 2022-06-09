#!/bin/sh
su - postgres /usr/local/bin/docker-entrypoint.sh postgres & 
su - root python3 /opt/api/app.py && fg