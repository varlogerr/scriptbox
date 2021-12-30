print_min_interval() {
  echo 5
}

print_help_opts() {
  while read -r l; do
    [[ -n "${l}" ]] && echo "${l}"
  done <<< "
    --pass  - (required) access token
    --hosts - (required) space separated hosts
    --ip    - (optional) specific IP
  "
}

print_help_usage() {
  while read -r l; do
    [[ -n "${l}" ]] && echo "${l}"
  done <<< "
    # update space separated hosts
    ${THE_SCRIPT} --pass '<token>' \\
      --hosts '<space-sep-domains>'
    # update space separated hosts to specific IP
    ${THE_SCRIPT} --pass '<token>' \\
      --ip '<ip>' --hosts '<space-sep-domains>'
  "
}

print_help_examples() {
  while read -r l; do
    [[ -n "${l}" ]] && echo "${l}"
  done <<< "
    ${THE_SCRIPT} --pass '123' \\
      --ip '1.1.1.1' --hosts 'foo bar'
  "
}
