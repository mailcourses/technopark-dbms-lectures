FROM golang:1.18-buster AS build

RUN mkdir /go/src/examples

COPY . /go/src/examples

WORKDIR /go/src/examples

RUN go build -o hello-world-server main.go

ENTRYPOINT ls -la /go/src

FROM ubuntu:20.04 AS release

MAINTAINER Nikita Strelkov

# Make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
RUN apt-get -y update && apt-get install -y locales gnupg2
RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8

# install Postgres
ENV PGVER 12
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y && apt-get install -y postgresql postgresql-contrib

# Run the rest of the commands as the ``postgres`` user created by the ``postgres-$PGVER`` package when it was ``apt installed``
USER postgres

# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
    createdb -E UTF8 docker &&\
    /etc/init.d/postgresql stop

# configure
RUN echo "listen_addresses='*'\n" >> /etc/postgresql/$PGVER/main/postgresql.conf
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/$PGVER/main/pg_hba.conf

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Back to the root user
USER root

# Собранный сервер
COPY --from=build /go/src/examples/hello-world-server /usr/bin/hello-world-server

# Expose the PostgreSQL port
EXPOSE 5432
# Expose web app port
EXPOSE 8090

CMD service postgresql start && hello-world-server
