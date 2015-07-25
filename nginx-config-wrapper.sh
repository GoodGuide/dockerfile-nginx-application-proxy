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

cat <<END-OF-CONFIG > /etc/nginx/conf.d/upstream
upstream upstream {
  server ${UPSTREAM_PORT_80_TCP##tcp://};
}
END-OF-CONFIG

cat <<'END-OF-CONFIG' > /etc/nginx/conf.d/default.conf
log_format default '"$request" $status $body_bytes_sent $request_time';

server {
    listen       80;
    server_name  localhost;
    root   /usr/share/nginx/html;
    access_log /dev/stdout default;

    location @app {
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-Host $host;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_pass http://upstream;
    }

    try_files $uri @app;
}
END-OF-CONFIG

exec "$@"
