#!/usr/bin/env bash

# https://github.com/ydns/bash-updater

THE_SCRIPT="$(basename "${BASH_SOURCE[0]}")"
TOOL_DIR="$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/..")"
API_URL="https://ydns.io/api/v1/update/?"
DDNS_PROVIDER="ydns"
IP_PROVIDER="https://ydns.io/api/v1/ip"

# source bootstrap
. "${TOOL_DIR}/bootstrap.sh"

if [[ -z "${DDNS_IP}" ]]; then
  DDNS_IP="$(get_current_ip)"
  if [[ -z "${DDNS_IP}" ]]; then
    echo "Can't detect current IP!"
    exit
  fi
fi

API_URL+="&ip=${DDNS_IP}"

print_log_nl "IP: ${DDNS_IP}"

for h in ${DDNS_HOSTS}; do
  result="$(
    curl -ks --basic -u "${DDNS_USER}:${DDNS_PASS}" \
      -K - <<< "url=${API_URL}&host=${h}"
  )"
  print_log_nl "(${h}) ${result}"
done
