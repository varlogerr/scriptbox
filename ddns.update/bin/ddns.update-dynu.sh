#!/usr/bin/env bash

# https://www.dynu.com/DynamicDNS/IP-Update-Protocol

THE_SCRIPT="$(basename "${BASH_SOURCE[0]}")"
TOOL_DIR="$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/..")"
API_URL="https://api.dynu.com/nic/update?"
DDNS_PROVIDER="dynu"

# source bootstrap
. "${TOOL_DIR}/bootstrap.sh"

if [[ -n "${DDNS_IP}" ]]; then
  API_URL+="&myip=${DDNS_IP}"
else
  DDNS_IP="$(get_current_ip)"
  if [[ -z "${DDNS_IP}" ]]; then
    DDNS_IP="NOT_DETECTED"
  fi
fi

print_log_nl "IP: ${DDNS_IP}"

if [[ -z "${DDNS_HOSTS}" ]]; then
  result="$(
    curl -ks --basic -u "${DDNS_USER}:${DDNS_PASS}" \
      -K - <<< "url=${API_URL}"
  )"
  print_log_nl "(all) ${result}"
  exit
fi

for h in ${DDNS_HOSTS}; do
  result="$(
    curl -ks --basic -u "${DDNS_USER}:${DDNS_PASS}" \
      -K - <<< "url=${API_URL}&hostname=${h}"
  )"
  print_log_nl "(${h}) ${result}"
done
