#!/bin/bash
DB_USER=$1
DB=movielens
set -e -x
psql "postgres://$DB_USER@localhost:5432/postgres?sslmode=disable"  -c "drop database if exists \"$DB\";"
psql "postgres://$DB_USER@localhost:5432/postgres?sslmode=disable"  -c "create database \"$DB\";"
wget -c http://files.grouplens.org/datasets/movielens/ml-latest.zip
unzip -o ml-latest.zip
psql "postgres://$DB_USER@localhost:5432/$DB?sslmode=disable" < load-pgsql.sql
pg_dump $DB > ml-latest.sql
