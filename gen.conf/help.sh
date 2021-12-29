print_help() {
  echo "Generate basic configuration files."
  echo

  echo "Usage:"
  echo "  $(basename "${THE_SCRIPT}") [TYPE]"
  echo "  $(basename "${THE_SCRIPT}") -l"

  echo

  echo "Available options:"
  while IFS='' read -r l; do
    grep -q '^\s*$' <<< "${l}" && continue
    echo "${l:2}"
  done <<< "
    -l, --list  list available conf file types
  "

  local listfile="./${THE_SCRIPT_NAME%.*}.conf"
  local scriptname="$(basename "${THE_SCRIPT}")"
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
