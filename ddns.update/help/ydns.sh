print_min_interval() {
  echo 15
}

print_help_opts() {
  while read -r l; do
    [[ -n "${l}" ]] && echo "${l}"
  done <<< "
    --user    (required) account username
    --pass    (required) account password
    --hosts   (required) space separated hosts
    --ip      (optional) specific IP
  "
}

print_help_usage() {
  while read -r l; do
    [[ -n "${l}" ]] && echo "${l}"
  done <<< "
    # update space separated hosts
    ${THE_SCRIPT} --user '<user>' \\
    --pass '<pass>' --hosts '<space-sep-hosts>'
    # update all hosts to specific IP
    ${THE_SCRIPT} --ip '<ip>' --user '<user>' \\
    --pass '<pass>' --hosts '<space-sep-hosts>'
  "
}

print_help_examples() {
  while read -r l; do
    [[ -n "${l}" ]] && echo "${l}"
  done <<< "
    ${THE_SCRIPT} --ip '1.1.1.1' \\
    --user 'foo' --pass 'bar' \\
    --hosts 'x.ydns.eu y.ydns.eu'
  "
}
