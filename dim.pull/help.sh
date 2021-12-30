print_help() {
  echo "Usage:"
  echo "  $(basename "${THE_SCRIPT}") [OPTIONS] [IMGS]"

  echo

  echo "Available options:"
  while IFS='' read -r l; do
    grep -q '^\s*$' <<< "${l}" && continue
    echo "${l:2}"
  done <<< "
    -f, --listfile  read images from a file, one image name
                    per line, lines starting with \`#\` and
                    empty lines are ignored
    -l, --limit     (defaults to ${page_size}) how many tags back to
                    pull. Don't use too high values
    -r, --remove    (flag) remove the pulled image, unless
                    it existed in the system before the
                    pull
    -h, -?, --help  print this help
  "

  local listfile="./dim-pull.conf"
  local scriptname="$(basename "${THE_SCRIPT}")"
  echo
  echo "Demo:"
  while read -r l; do
    [[ -n "${l}" ]] && echo "  ${l}"
  done <<< "
    # pull 5 tags of images from ${listfile},
    # plus ubuntu and delete them after pull
    ${scriptname} -l 5 -r -f ${listfile} ubuntu
    # pull latest version of ubuntu image
    ${scriptname} ubuntu
  "
}
