#!/usr/bin/env bash

function endless_input {
  i=0
  while : ; do
    VAL=`openssl rand -base64 32`
    KEY=key`openssl rand -base64 32`
    PORT=`master_port`
    redis-cli -p $PORT SET $KEY $VAL &>/dev/null
    i=$((i+1))
    if [ "$(($i % 100))" -eq "0" ]; then
      printf "\033c"
      echo "======================================================"
      echo "Master is on port $PORT"
      echo "7777 `redis-cli -p 7777 info keyspace 2>/dev/null`"
      echo "6666 `redis-cli -p 6666 info keyspace 2>/dev/null`"
      echo "8888 `redis-cli -p 8888 info keyspace 2>/dev/null`"
    fi
  done
}

master_pid() {
  port=`master_port`
  echo `lsof -i:$port | grep LISTEN | awk -F' ' 'NR==1{print $2}'`
}

master_port() {
  echo `redis-cli -p 26379 sentinel get-master-addr-by-name mymaster | awk -F'"' 'NR==2{print $1}'`
}

dir_port() {
  case $1 in
    '6666') echo 'redis1';;
    '7777') echo 'redis2';;
    '8888') echo 'redis3';;
  esac
}

function startredis {
  pushd $1 > /dev/null
  redis-server config > /dev/null &
  popd > /dev/null
}

function killmaster {
  while : ; do
    sleep 10
    PID=`master_pid`
    PORT=`master_port`
    DIRNAME=`dir_port $PORT`
    echo "killing $DIRNAME on port $PORT"
    kill -9 $PID 2>&1 > /dev/null
    sleep 10
    echo "starting $DIRNAME on port $PORT"
    startredis $DIRNAME
  done
}
