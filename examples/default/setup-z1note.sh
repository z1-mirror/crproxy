#!/usr/bin/env bash

domain=${1:-}

if [[ -z "${domain}" ]]; then
    echo "domain is required"
    exit 1
fi

origin=${2:-}

if [[ -z "${origin}" ]]; then
    echo "origin is required"
    exit 1
fi

gateway=${3:-}

if [[ -z "${gateway}" ]]; then
    echo "gateway is required"
    exit 1
fi

function gen() {
    local domain=$1
    local origin=$2
    local gateway=$3
    cat <<EOF
server {
    listen 80;
    server_name ${domain};
    server_tokens off;

    client_max_body_size 100M;

    access_log  /var/log/nginx/${domain}.access.log  main;

    location / {
        proxy_pass https://192.168.0.20:5443;

        # 保留并传递原始请求中的Authorization头
        proxy_set_header Authorization \$http_authorization;
        # 其他常用的传递头
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF
}

conf="nginx/z1note-${domain}.conf"

if [ ! -f "${conf}" ]; then
    mkdir -p nginx
    gen "${domain}" "${origin}" "${gateway}" >"${conf}"
fi
