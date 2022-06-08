FROM aa8y/postgres-dataset:dellstore

MAINTAINER Nelson Carrasquel <carrasquel@outlook.com>

ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools
WORKDIR /opt/api
COPY . .
RUN pip3 install -r requirements.txt
ENV POSTGRES_USER="postgres"
ENV POSTGRES_PASSWORD="postgres"
ENV POSTGRES_HOST="localhost"
ENV POSTGRES_PORT="5432"
ENV POSTGRES_DB="dellstore"
RUN ["chmod", "+x", "/opt/notsendgrid/bin/notsendgrid_exec.sh"]
EXPOSE 5000
CMD ./bin/notsendgrid_exec.sh