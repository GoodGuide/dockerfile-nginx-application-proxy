#!/bin/ash

set -eu

# make sure the required configuration variables have been supplied
[[ ${upstream_server_address} ]]

for f in $(find /etc/nginx/ -type f -name '*.conf.tmpl'); do
	output="${f/.conf.tmpl/.conf}"
	envsubst '${upstream_server_address}' < "$f" > "$output"
	echo "envsubst: $f -> $output" >&2
done

echo "exec $@" >&2
exec "$@"
