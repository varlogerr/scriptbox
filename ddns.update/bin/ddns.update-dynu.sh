#!/usr/bin/env bash

# https://www.dynu.com/DynamicDNS/IP-Update-Protocol

THE_SCRIPT="$(basename "${BASH_SOURCE[0]}")"
TOOL_DIR="$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/..")"
API_URL="https://api.dynu.com/nic/update?"
DDNS_PROVIDER="ddns"

print_help() {
  echo "Minimal update interval: 5 min"
  echo
  echo "Available environment variables:"
  while read -r l; do
    [[ -n "${l}" ]] && echo "  ${l}"
  done <<< "
    DDNS_USER  - (required) account username
    DDNS_PASS  - (required) account password
    DDNS_HOSTS - (optional) space separated hosts
    DDNS_IP    - (optional) specific IP
  "
  echo
  echo "Usage:"
  local offset=2; while read -r l; do
    [[ -n "${l}" ]] && printf -- "%-${offset}s%s\\n" '' "${l}"
    [[ "${l: -1}" == '\' ]] && offset=4 || offset=2
  done <<< "
    # update all hosts
    DDNS_USER='<user>' DDNS_PASS='<pass>' \\
    ${THE_SCRIPT}
    # update space separated hosts
    DDNS_USER='<user>' DDNS_PASS='<pass>' \\
    DDNS_HOSTS='<space-sep-hosts>' \\
    ${THE_SCRIPT}
    # update all hosts to specific IP
    DDNS_USER='<user>' DDNS_PASS='<pass>' \\
    DDNS_IP='<some-ip>' \\
    ${THE_SCRIPT}
  "
  echo
  echo "Examples:"
  local offset=2; while read -r l; do
    [[ -n "${l}" ]] && printf -- "%-${offset}s%s\\n" '' "${l}"
    [[ "${l: -1}" == '\' ]] && offset=4 || offset=2
  done <<< "
    DDNS_USER='foo' DDNS_PASS='bar' \\
    DDNS_HOSTS='x.freeddns.org y.freeddns.org' \\
    DDNS_IP='1.2.3.4' \\
    ${THE_SCRIPT}
  "
}

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
