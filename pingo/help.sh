print_help() {
  echo "Available options:"
  while IFS='' read -r l; do
    grep -q '^\s*$' <<< "${l}" && continue
    echo "${l:2}"
  done <<< "
    -h, -?, --help  print this help
    -c, --count     how many packets to send in a set
                    (\`ping -c\` option), defaults to ${COUNT}
    -o, --output    output file, defaults to ${OUTPUT}
    -i, --interval  interval between sets in seconds,
                    defaults to ${INTERVAL}. Set to 0 to not repeat
  "

  local log_file="./${THE_SCRIPT_NAME%.*}.log"
  echo
  echo "Demo:"
  while read -r l; do
    [[ -n "${l}" ]] && echo "  ${l}"
  done <<< "
    $(basename "${THE_SCRIPT}") -c ${COUNT} -i ${INTERVAL} -o ${log_file} google.com
  "
}
