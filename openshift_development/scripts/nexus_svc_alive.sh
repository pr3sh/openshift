#!/bin/sh
curl -si -u admin:$(cat /nexus-data/admin.password) \
  http://localhost:8081/service/metrics/healthcheck | grep healthy | \
  grep true
