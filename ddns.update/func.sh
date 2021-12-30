get_current_ip() {
  local ip_provider="${IP_PROVIDER:-https://ifconfig.me}"
  curl -ks "${ip_provider}"
}

print_log() {
  local msg="${1}"
  local provider="${DDNS_PROVIDER:-unknown}"
  printf -- '[%s: %s] %s' \
    "${provider}" "$(get_ts)" "${msg}"
}

print_log_nl() {
  local msg="${1}"
  print_log "${msg}"$'\n'
}
