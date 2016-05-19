#!/bin/sh

function start {
  pushd $1
  redis-server config &
  popd
}


redis-sentinel sentinel.conf &

for i in $(seq 1 3); do
  start redis$i
done

./endless.sh
