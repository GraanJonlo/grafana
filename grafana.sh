#!/bin/bash
/usr/local/bin/confd -onetime -backend env

mkdir -p /grafana/data/log

chown grafana:grafana /data
chown grafana:grafana /var/logs/grafana
chown grafana:grafana /grafana/data/log
chown grafana:grafana /grafana/data/plugins
chmod 0755 /data
chmod 0755 /var/logs/grafana
chmod 0755 /grafana/data/log
chmod 0755 /grafana/data/plugins

cd /grafana
exec /sbin/setuser grafana /grafana/bin/grafana-server web