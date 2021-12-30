#!/usr/bin/env bash

# https://www.duckdns.org/spec.jsp
# https://www.duckdns.org/install.jsp

THE_SCRIPT="$(basename "${BASH_SOURCE[0]}")"
TOOL_DIR="$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/..")"
API_URL="https://www.duckdns.org/update?"
DDNS_PROVIDER="duckdns"

# source bootstrap
. "${TOOL_DIR}/bootstrap.sh"

if [[ -n "${DDNS_IP}" ]]; then
  API_URL+="&ip=${DDNS_IP}"
else
  DDNS_IP="$(get_current_ip)"
  if [[ -z "${DDNS_IP}" ]]; then
    DDNS_IP="NOT_DETECTED"
  fi
fi

print_log_nl "IP: ${DDNS_IP}"

csv_domains="$(
  printf -- '%s' "$(xargs <<< "${DDNS_HOSTS}")" \
  | tr '\n' ' ' | sed -E 's/\s+/,/g'
)"
API_URL+="&domains=${csv_domains}&token=${DDNS_PASS}"

result="$(
  curl -ks -K - <<< "url=${API_URL}"
)"
for d in ${DDNS_HOSTS}; do
  print_log_nl "(${d}) ${result}"
done
