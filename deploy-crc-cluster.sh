#!/bin/bash 

crc cleanup

crc setup

crc start --cpus 6 --memory 18432 --disk-size 100     \
	   --pull-secret-file $HOME/Downloads/pull-secret.txt
