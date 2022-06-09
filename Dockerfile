FROM postgres

MAINTAINER Nelson Carrasquel <carrasquel@outlook.com>

RUN mkdir -p /tmp/psql_data/

COPY bin/init_docker_postgres.sh /docker-entrypoint-initdb.d/

RUN apk add --update \
      bash \
      ca-certificates \
      wget

WORKDIR /tmp/psql_data

RUN wget -c https://ftp.postgresql.org/pub/projects/pgFoundry/dbsamples/dellstore2/dellstore2-normal-1.0/dellstore2-normal-1.0.tar.gz -O - | tar -xz

WORKDIR /opt/api

ENV POSTGRES_USER="postgres"
ENV POSTGRES_PASSWORD="postgres"
ENV POSTGRES_HOST="localhost"
ENV POSTGRES_PORT="5432"
ENV POSTGRES_DB="dellstore"

USER root
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

COPY . .
RUN pip3 install -r requirements.txt

RUN ["chmod", "+x", "/opt/api/bin/notsendgrid_exec.sh"]
EXPOSE 5000
CMD ./bin/notsendgrid_exec.sh