print_help_short() {
  echo "Update dynamic DNS for ${DDNS_PROVIDER} provider."
  if [[ "$(type -t print_min_interval)" == 'function' ]]; then
    echo "Minimal recommended update interval: $(print_min_interval) min"
    echo
  fi

  local help_opts="$(
    if [[ "$(type -t print_help_opts)" == 'function' ]]; then
      print_help_opts
    fi
  )"

  echo "Available options:"
  while read -r l; do
    [[ -n "${l}" ]] && echo "  ${l}"
  done <<< "
    ${help_opts}
    $( while read -r l; do
      [[ -n "${l}" ]] && echo "${l}"
    done <<< "
      -h, -?, --help  print help
      --short-help    print short help
    ")
  "
}

print_help() {
  print_help_short
  echo

  if [[ "$(type -t print_help_opts)" == 'function' ]]; then
    env_prefix=DDNS_
    offset=6; while IFS='' read -r l; do
      l="${l:${offset}}"
      [[ -n "${l}" ]] && echo "${l}"
    done <<< "
      Environment variables can be used instead of
      inline options. They should be in upper case
      and prepended with \`${env_prefix}\`. Inline
      options take precedence over environment
      variables. Example:
        # in both cases '1.1.1.1' is used for IP
        ${THE_SCRIPT} --ip 1.1.1.1 ...
        ${env_prefix}IP=1.1.1.1 ${THE_SCRIPT} ...
        # '2.2.2.2' wins
        ${env_prefix}IP=1.1.1.1 ${THE_SCRIPT} \\
          --ip 2.2.2.2
    "
    echo
  fi

  if [[ "$(type -t print_help_usage)" == 'function' ]]; then
    echo "Usage:"
    local offset=2; while read -r l; do
      printf -- "%-${offset}s%s\\n" '' "${l}"
      [[ "${l: -1}" == '\' ]] && offset=4 || offset=2
    done <<< "$(print_help_usage)"
    echo
  fi

  if [[ "$(type -t print_help_examples)" == 'function' ]]; then
    echo "Examples:"
    local offset=2; while read -r l; do
      [[ -n "${l}" ]] && printf -- "%-${offset}s%s\\n" '' "${l}"
      [[ "${l: -1}" == '\' ]] && offset=4 || offset=2
    done <<< "$(print_help_examples)"
  fi
}
