#!/usr/bin/env bash

# https://github.com/ydns/bash-updater

THE_SCRIPT="$(basename "${BASH_SOURCE[0]}")"
TOOL_DIR="$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/..")"
API_URL="https://ydns.io/api/v1/update/?"
DDNS_PROVIDER="ydns"
IP_PROVIDER="https://ydns.io/api/v1/ip"

print_help() {
  echo "Minimal update interval: 15 min"
  echo
  echo "Available environment variables:"
  while read -r l; do
    [[ -n "${l}" ]] && echo "  ${l}"
  done <<< "
    DDNS_USER  - (required) account username
    DDNS_PASS  - (required) account password
    DDNS_HOSTS - (required) space separated hosts
    DDNS_IP    - (optional) specific IP
  "
  echo
  echo "Usage:"
  local offset=2; while read -r l; do
    [[ -n "${l}" ]] && printf -- "%-${offset}s%s\\n" '' "${l}"
    [[ "${l: -1}" == '\' ]] && offset=4 || offset=2
  done <<< "
    # update space separated hosts
    DDNS_USER='<user>' DDNS_PASS='<pass>' \\
    DDNS_HOSTS='<space-sep-hosts>' \\
    ${THE_SCRIPT}
    # update all hosts to specific IP
    DDNS_USER='<user>' DDNS_PASS='<pass>' \\
    DDNS_IP='<some-ip>' \\
    DDNS_HOSTS='<space-sep-hosts>' \\
    ${THE_SCRIPT}
  "
  echo
  echo "Examples:"
  local offset=2; while read -r l; do
    [[ -n "${l}" ]] && printf -- "%-${offset}s%s\\n" '' "${l}"
    [[ "${l: -1}" == '\' ]] && offset=4 || offset=2
  done <<< "
    DDNS_USER='foo' DDNS_PASS='bar' \\
    DDNS_HOSTS='x.ydns.eu y.ydns.eu' \\
    DDNS_IP='1.2.3.4' \\
    ${THE_SCRIPT}
  "
}

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
