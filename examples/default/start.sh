#!/usr/bin/env bash

docker-compose up -d

gateway=myzero1.xyz
subDomains=docker.myzero1.xyz,z1note.myzero1.xyz

declare -A mapping=()

#./setup-gateway.sh "${gateway}" "registry:5000"
./setup-gateway.sh "${gateway}" "crproxy:8080"
./update-tls.sh "${gateway},${subDomains}"

for key in ${!mapping[*]}; do
  ./setup-alias.sh "${key}" "${mapping[$key]}" "${gateway}"
  ./update-tls.sh "${key}"
done

cp nginx/sub-domain-docker.myzero1.xyz.conf.dist nginx/sub-domain-docker.myzero1.xyz.conf
cp nginx/sub-domain-z1note.myzero1.xyz.conf.dist nginx/sub-domain-z1note.myzero1.xyz.conf