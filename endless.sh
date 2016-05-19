#!/bin/sh
i=0
while : ; do
  VAL=`openssl rand -base64 32`
  KEY=key`openssl rand -base64 32`
  PORT=`redis-cli -p 26379 sentinel get-master-addr-by-name mymaster | awk -F'"' 'NR==2{print $1}'`
  redis-cli -p $PORT SET $KEY $VAL > /dev/null
  i=$((i+1))
  if [ "$(($i % 100))" -eq "0" ]; then
    echo "7777 `redis-cli -p 7777 info keyspace`"
    echo "6666 `redis-cli -p 6666 info keyspace`"
    echo "8888 `redis-cli -p 8888 info keyspace`"
  fi
done
