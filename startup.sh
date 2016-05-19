#!/usr/bin/env bash

source func.sh

for i in $(seq 1 3); do
  startredis redis$i
done

redis-sentinel sentinel.conf > /dev/null &

killmaster
