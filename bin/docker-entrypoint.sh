#!/bin/bash

cd /opt/datart/bin/
mkdir -p /initdb
cat datart.sql > /initdb/datart.sql
sed -i '1i\SET GLOBAL log_bin_trust_function_creators = 1;' /initdb/datart.sql


set -e

host="$1"
shift
cmd="$@"

until [ $(curl -I -m 5 -o /dev/null -s -w %{remote_port} $host) -gt 0 ]; do
  >&2 echo "database is unavailable - sleeping"
  sleep 1
done

cd $DATART3_HOME

java -Dfile.encoding=UTF-8 -cp $JAVA_HOME/lib/*:lib/* datart.DatartServerApplication