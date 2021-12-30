print_min_interval() {
  echo 5
}

print_help_opts() {
  while read -r l; do
    [[ -n "${l}" ]] && echo "${l}"
  done <<< "
    --user    (required) account username
    --pass    (required) account password
    --hosts   (optional) space separated hosts
    --ip      (optional) specific IP
  "
}

print_help_usage() {
  while read -r l; do
    [[ -n "${l}" ]] && echo "${l}"
  done <<< "
    # update all hosts
    ${THE_SCRIPT} --user '<user>' \\
    --pass '<pass>'
    # update space separated hosts
    ${THE_SCRIPT} --user '<user>' \\
    --pass '<pass>' \\
    --hosts '<space-sep-hosts>'
    # update all hosts to specific IP
    ${THE_SCRIPT} --ip '<some-ip>' \\
    --user '<user>' --pass '<pass>'
  "
}

print_help_examples() {
  while read -r l; do
    [[ -n "${l}" ]] && echo "${l}"
  done <<< "
    ${THE_SCRIPT} --ip '1.1.1.1' \\
    --user 'foo' --pass 'bar' \\
    --hosts 'x.giize.com y.giize.com'
  "
}
