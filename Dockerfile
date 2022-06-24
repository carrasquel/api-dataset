FROM postgres:alpine as dumper

MAINTAINER Nelson Carrasquel <carrasquel@outlook.com>

RUN mkdir -p /tmp/psql_data/

RUN apk add --update \
      bash \
      ca-certificates \
      wget \
      supervisor

WORKDIR /tmp/psql_data

RUN wget -c https://github.com/devrimgunduz/pagila/archive/refs/tags/v2.1.0.tar.gz -O - | tar -xz
RUN cat ./pagila-2.1.0/pagila-schema.sql ./pagila-2.1.0/pagila-data.sql > ./pagila-2.1.0/pagila-init.sql

FROM postgres:alpine

COPY --from=dumper /tmp/psql_data/pagila-2.1.0/pagila-init.sql /docker-entrypoint-initdb.d/pagila-init.sql

WORKDIR /opt/api

ENV POSTGRES_USER="postgres"
ENV POSTGRES_PASSWORD="postgres"
ENV POSTGRES_HOST="localhost"
ENV POSTGRES_PORT="5432"
ENV POSTGRES_DB="pagila"

ENV PYTHONUNBUFFERED=1
RUN apk add supervisor
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

COPY . .
RUN pip3 install -r requirements.txt
EXPOSE 5000
EXPOSE 5432
RUN mkdir -p /var/log/supervisor

COPY supervisord.conf /etc/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]