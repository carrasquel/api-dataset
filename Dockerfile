FROM postgres:alpine as dumper

MAINTAINER Nelson Carrasquel <carrasquel@outlook.com>

RUN mkdir -p /tmp/psql_data/

RUN apk add --update \
      bash \
      ca-certificates \
      wget \
      supervisor

WORKDIR /tmp/psql_data

RUN wget -c https://ftp.postgresql.org/pub/projects/pgFoundry/dbsamples/dellstore2/dellstore2-normal-1.0/dellstore2-normal-1.0.tar.gz -O - | tar -xz

FROM postgres:alpine

COPY --from=dumper /tmp/psql_data/dellstore2-normal-1.0/dellstore2-normal-1.0.sql /docker-entrypoint-initdb.d/

WORKDIR /opt/api

ENV POSTGRES_USER="postgres"
ENV POSTGRES_PASSWORD="postgres"
ENV POSTGRES_HOST="localhost"
ENV POSTGRES_PORT="5432"
ENV POSTGRES_DB="dellstore"

# USER root
ENV PYTHONUNBUFFERED=1
RUN apk add supervisor
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

COPY . .
RUN pip3 install -r requirements.txt
EXPOSE 5000
RUN mkdir -p /var/log/supervisor
# RUN ["chmod", "+x", "/opt/api/bin/notsendgrid_exec.sh"]
# RUN ["/usr/local/bin/docker-entrypoint.sh", "postgres"]
# CMD ./bin/notsendgrid_exec.sh
COPY supervisord.conf /etc/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]