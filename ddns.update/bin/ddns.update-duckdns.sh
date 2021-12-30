#!/usr/bin/env bash

# https://www.duckdns.org/spec.jsp
# https://www.duckdns.org/install.jsp

THE_SCRIPT="$(basename "${BASH_SOURCE[0]}")"
TOOL_DIR="$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/..")"
API_URL="https://www.duckdns.org/update?"
DDNS_PROVIDER="duckdns"

print_help() {
  echo "Minimal update interval: 5 min"
  echo
  echo "Available environment variables:"
  while read -r l; do
    [[ -n "${l}" ]] && echo "  ${l}"
  done <<< "
    DDNS_TOKEN - (required) access token
    DDNS_HOSTS - (required) space separated hosts
    DDNS_IP    - (optional) specific IP
  "
  echo
  echo "Usage:"
  local offset=2; while read -r l; do
    [[ -n "${l}" ]] && printf -- "%-${offset}s%s\\n" '' "${l}"
    [[ "${l: -1}" == '\' ]] && offset=4 || offset=2
  done <<< "
    # update space separated domains
    DDNS_TOKEN='<token>' \\
    DDNS_HOSTS='<space-sep-domains>' \\
    ${THE_SCRIPT}
    # update space separated domains
    # to specific IP
    DDNS_TOKEN='<token>' \\
    DDNS_HOSTS='<space-sep-hosts>' \\
    DDNS_IP='<some-ip>' \\
    ${THE_SCRIPT}
  "
  echo
  echo "Examples:"
  local offset=2; while read -r l; do
    [[ -n "${l}" ]] && printf -- "%-${offset}s%s\\n" '' "${l}"
    [[ "${l: -1}" == '\' ]] && offset=4 || offset=2
  done <<< "
    DDNS_TOKEN='123' \\
    DDNS_HOSTS='foo bar' \\
    DDNS_IP='1.2.3.4' \\
    ${THE_SCRIPT}
  "
}

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

csv_domains="$(sed -E 's/\s+/,/g' <<< ${DDNS_HOSTS})"
API_URL+="&domains=${csv_domains}&token=${DDNS_TOKEN}"

result="$(
  curl -ks -K - <<< "url=${API_URL}"
)"
for d in ${DDNS_HOSTS}; do
  print_log_nl "(${d}) ${result}"
done
