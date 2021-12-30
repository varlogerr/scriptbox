print_help() {
  local scriptname="$(basename "${THE_SCRIPT}")"

  echo "Generate basic configuration files."
  echo

  echo "Usage:"
  echo "  ${scriptname} [TYPE]"
  echo "  ${scriptname} -l"

  echo

  echo "Available options:"
  while IFS='' read -r l; do
    grep -q '^\s*$' <<< "${l}" && continue
    echo "${l:2}"
  done <<< "
    -l, --list  list available conf file types
  "

  echo
  echo "Demo:"
  while read -r l; do
    [[ -n "${l}" ]] && echo "  ${l}"
  done <<< "
    # list available types,
    ${scriptname} -l
    # generate editorconfig to .editorconfig file
    ${scriptname} editorconfig > .editorconfig
  "
}
