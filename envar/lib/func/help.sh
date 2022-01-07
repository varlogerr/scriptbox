__envar.help_main() {
  local file_path="${BASH_SOURCE[0]}"
  local file_dir="$(dirname "$(realpath "${file_path}")")"
  local funcdir="$(realpath "${file_dir}")"
  local main_content="$()"
  local export_lines="$(
    cat "${funcdir}/envar.sh" \
    | grep -Pn '^s*export\s+\-f\s+[^_]'
  )"

  while read -r l; do
    [[ -n "${l}" ]] && echo "${l}"
  done <<< "
    For each function \`<func> --help\` prints
    detailed help.
    Issue \`envar.help --demo\` to see usage demos
  "
  echo

  local funcname
  echo "Available functions:"
  while read -r l; do
    rev <<< "${l}" | cut -d' ' -f1 | rev
  done <<< "${export_lines}" \
  | while read -r f; do
    printf '%-2s%s\n' '' "${f}"

    __envar.func_help "${f}" --help \
    | while read -r l; do
      [[ -z "${l}" ]] && break

      printf '%-4s%s\n' '' "${l}"
    done
  done
}
export -f __envar.help_main

__envar.help_demo() {
  local assetsdir="$(
    dirname "${BASH_SOURCE[0]}"
  )/../assets/help"

  echo "Initial directory structure:"
  grep -vFx '' "${assetsdir}/dir-struct.sh" \
  | sed 's/^/  /g'

  echo
  echo "Files demo content:"
  grep -vFx '' "${assetsdir}/files-demo.sh" \
  | sed 's/^/  /g'

  echo
  echo "Demo (anonymous):"
  grep -vFx '' "${assetsdir}/demo-anonymous.sh" \
  | sed 's/^/  /g'

  echo
  echo "Demo (env paths):"
  grep -vFx '' "${assetsdir}/demo-env-paths.sh" \
  | sed 's/^/  /g'

  echo
  echo "Demo (pathfile):"
  grep -vFx '' "${assetsdir}/demo-pathfile.sh" \
  | sed 's/^/  /g'

  echo
  echo "Demo (pending):"
  grep -vFx '' "${assetsdir}/demo-pending.sh" \
  | sed 's/^/  /g'

  echo
  echo "Demo (deskless):"
  grep -vFx '' "${assetsdir}/demo-deskless.sh" \
  | sed 's/^/  /g'
}
export -f __envar.help_demo

__envar.func_help() {
  local funcname="${1}"
  shift
  local is_help=0
  while :; do
    [[ -z "${1+x}" ]] && break

    case "${1}" in
      -h|-\?|--help)  is_help=1 ;;
      *)              ;;
    esac

    shift
  done

  [[ ${is_help} -eq 0 ]] && return 1

  local file_path="${BASH_SOURCE[0]}"
  local file_dir="$(dirname "$(realpath "${file_path}")")"
  local funcdir="$(realpath "${file_dir}")"
  local func_content="$(cat "${funcdir}/envar.sh")"
  local funcname_escaped="$(sed 's/\./\\./g' <<< "${funcname}")"
  local func_lineno="$(
    grep -Pn '^s*export\s+\-f\s+'"${funcname_escaped}\$" <<< "${func_content}" \
    | cut -d: -f1
  )"

  local content_tac="$(head -n "$((func_lineno - 1))" <<< "${func_content}" | tac)"
  local end_line="$(grep -vn '^#' <<< "${content_tac}" | head -n 1 | cut -d: -f1)"
  local help_msg="$(
    head -n $((end_line - 1)) <<< "${content_tac}" \
    | tac | sed -E 's/^#(\s)?//g'
  )"
  [[ -n "${help_msg}" ]] && echo "${help_msg}"
}
export -f __envar.func_help
