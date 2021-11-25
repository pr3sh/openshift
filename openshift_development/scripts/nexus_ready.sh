#!/bin/sh
curl -si -u admin:$(cat /nexus-data/admin.password) \ 1
  http://localhost:8081/service/metrics/ping | grep pong 2
