Simple redis sentinel demo
==========================

Uses only 1 sentinel node :O


The `startup.sh` script:

* Starts 3 sentinel nodes, on 6666, 7777, 8888

* Kills the master every 10 seconds, during 10 seconds, and then restarts the node

The `monitor.sh` scripts: 

* Writes random keys on the master

* Shows the actual master and the amount of keys in each node(if alive) every 100 writes
