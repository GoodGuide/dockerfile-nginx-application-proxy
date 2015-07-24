#!/bin/bash

set -e

if [[ -n ${UPSTREAM_ENV_STATIC_FILES_VOLUME} && -d ${UPSTREAM_ENV_STATIC_FILES_VOLUME} ]]; then
  echo "Using STATIC_FILES_VOLUME at ${UPSTREAM_ENV_STATIC_FILES_VOLUME}" >&2
  rm -rf /usr/share/nginx/html
  ln -sf ${UPSTREAM_ENV_STATIC_FILES_VOLUME} /usr/share/nginx/html
fi

if [[ -z ${UPSTREAM_PORT_80_TCP} ]]; then
  echo 'You must link a container exposing port 80 as `upstream`' >&2
fi

cat <<END-OF-CONFIG > /etc/nginx/conf.d/default.conf
upstream upstream {
  server ${UPSTREAM_PORT_80_TCP##tcp://};
}

server {
    listen       80;
    server_name  localhost;
    root   /usr/share/nginx/html;

    location @app {
      proxy_set_header Host \$host;
      proxy_set_header X-Real-IP \$remote_addr;
      proxy_pass http://upstream;
    }

    try_files \$uri @app;
}
END-OF-CONFIG

exec "$@"
