#!/bin/sh
postgres & python3 /opt/api/app.py && fg