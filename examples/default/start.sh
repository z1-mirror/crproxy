#!/usr/bin/env bash

docker-compose up -d

# gateway=cr.zsm.io
gateway=crproxy.myzero1.xyz

declare -A mapping=()
mapping["docker.${gateway}"]="docker.io"

#./setup-gateway.sh "${gateway}" "registry:5000"
./setup-gateway.sh "${gateway}" "crproxy:8080"
./update-tls.sh "${gateway}"

for key in ${!mapping[*]}; do
    ./setup-alias.sh "${key}" "${mapping[$key]}" "${gateway}"
    ./update-tls.sh "${key}"
done

key="z1note.myzero1.xyz"
./setup-z1note.sh "${key}" "1" "${gateway}"
./update-tls.sh "${key}"

key="chat.myzero1.xyz"
./setup-chat.sh "${key}" "1" "${gateway}"
./update-tls.sh "${key}"