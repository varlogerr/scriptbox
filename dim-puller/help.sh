print_help() {
  echo "Usage:"
  echo "  $(basename "${THE_SCRIPT}") [OPTIONS] [IMGS]"

  echo

  echo "Available options:"
  while IFS='' read -r l; do
    grep -q '^\s*$' <<< "${l}" && continue
    echo "${l:2}"
  done <<< "
    -h, -?, --help  print this help
    -f, --listfile  read images from a file, one image
                    name per line, lines starting with
                    \`#\` and empty lines are ignored
    -a, --all       pull all tags. Without this flat
                    only the latest image will be pulled,
                    where latest means latest by upload
                    date, not necessarily ':latest' tag
    -r, --remove    remove the pulled image, unless it
                    existed in the system before the pull
  "

  local listfile="./${THE_SCRIPT_NAME%.*}.conf"
  local scriptname="$(basename "${THE_SCRIPT}")"
  echo
  echo "Demo:"
  while read -r l; do
    [[ -n "${l}" ]] && echo "  ${l}"
  done <<< "
    # pull all tags of images from ${listfile},
    # plus ubuntu and delete them after pull
    ${scriptname} -a -r -f ${listfile} ubuntu
    # pull latest version of ubuntu image
    ${scriptname} ubuntu
  "
}
