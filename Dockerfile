FROM phusion/baseimage:0.9.19

MAINTAINER Andy Grant <andy.a.grant@gmail.com>

ADD https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 /usr/local/bin/confd
RUN chmod +x /usr/local/bin/confd

RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

RUN \
  apt-get install -y \
  git \
  libsqlite3-dev \
  sqlite3 \
  wget

RUN rm -rf /var/lib/apt/lists/*

ENV GRAFANA_VERSION 3.1.1-1470047149

RUN \
  cd /tmp && \
  wget https://grafanarel.s3.amazonaws.com/builds/grafana-$GRAFANA_VERSION.linux-x64.tar.gz && \
  tar xvzf grafana-$GRAFANA_VERSION.linux-x64.tar.gz && \
  mv grafana-$GRAFANA_VERSION /grafana && \
  groupadd grafana && \
  useradd -g grafana grafana && \
  rm -rf /tmp/*

RUN \
  mkdir -p /grafana/data/plugins && \
  cd /grafana/data/plugins && \
  git clone --depth 1 https://github.com/grafana/piechart-panel.git && \
  git clone --depth 1 https://github.com/grafana/worldmap-panel.git

VOLUME ["/data"]
VOLUME ["/var/logs/grafana"]

RUN mkdir -p /etc/service/grafana
ADD grafana.sh /etc/service/grafana/run

ADD grafana.toml /etc/confd/conf.d/grafana.toml
ADD config.ini.tmpl /etc/confd/templates/config.ini.tmpl

EXPOSE 3000

CMD ["/sbin/my_init", "--quiet"]