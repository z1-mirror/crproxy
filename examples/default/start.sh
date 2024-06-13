#!/usr/bin/env bash

docker-compose up -d

gateway=myzero1.xyz
subDomains=docker.myzero1.xyz,z1note.myzero1.xyz

declare -A mapping=()

#./setup-gateway.sh "${gateway}" "registry:5000"
./setup-gateway.sh "${gateway}" "crproxy:8080"
./update-tls.sh "${gateway}"

for key in ${!mapping[*]}; do
  ./setup-alias.sh "${key}" "${mapping[$key]}" "${gateway}"
  ./update-tls.sh "${key}"
done

# docker-compose exec gateway certbot --nginx -n --rsa-key-size 4096 --agree-tos --register-unsafely-without-email --domains myzero1.xyz,docker.myzero1.xyz --expand
docker-compose exec gateway certbot --nginx -n --rsa-key-size 4096 --agree-tos --register-unsafely-without-email --domains $gateway,$subDomains --expand
