envar.help() {
  __envar.func_help "${FUNCNAME[0]}" "${@}" && return

  while :; do
    [[ -z "${1+x}" ]] && break

    case "${1}" in
      --desk)     __envar.help_desk; return ;;
      --deskless) __envar.help_deskless; return ;;
    esac

    shift
  done

  __envar.help_main
}

__envar.help_main() {
  local file_path="${BASH_SOURCE[0]}"
  local file_dir="$(dirname "$(realpath "${file_path}")")"
  local libdir="$(realpath "${file_dir}/..")"
  local main_content="$(cat "${libdir}/main.sh")"
  local export_lines="$(
    grep -Pn '^s*export\s+\-f\s+[^_]' <<< "${main_content}"
  )"

  while read -r l; do
    [[ -n "${l}" ]] && echo "${l}"
  done <<< "
    For each function \`<func> --help\` prints
    detailed help.
    Issue \`envar.help --desk\` and
    \`envar.help --deskless\` to see demos on
    usage in desk and deskless modes.
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

__envar.help_desk() {
  echo "Initial directory structure:"
  while read -r l; do
    [[ -n "${l}" ]] && echo "  ${l}"
  done <<< "
    ├── env1/
    │   ├── env1-1.sh
    │   └── env1-2.sh
    └── env2.sh
  "
  echo

  echo "Demo env file:"
  while read -r l; do
    [[ -n "${l}" ]] && echo "  ${l}"
  done <<< "
    # cat ./env1/env1-1.sh
    export ENV_VAR11=11
  "
  echo

  echo "Desk mode demo:"
  while read -r l; do
    [[ -z "${l}" ]] && continue

    [[ -n "${l}" ]] && echo "  ${l}"
    [[ ("${l:0:1}" != '#' && "${l: -1}" = '\') ]] \
      && printf '%-2s' ''
  done <<< "
    # create 'myenv' desk, source existing
    # paths and add non-existing ones to pending
    envrc.source -n myenv ./env1 ./env2.sh \\
      ./env3 ./env4
    # validate path environments are loaded
    echo \${ENV_VAR11}
    # list sourced paths and sourced files
    envar.path; envar.files
    # list all paths requested to be sourced
    # (sourced and pending)
    envar.req
    # list pending paths
    envar.pending
    # crete a new environment in a sourced path,
    # remove an existing one, check status for
    # changes and reload the environment to pick
    # up the changes
    touch ./env1/env1-3.sh
    rm ./env1/env1-1.sh
    envar.status
    envar.reload
    # create a pending path from pending list
    # and reload the environment
    mkdir ./env3
    echo 'export ENV_VAR31=31' \\
      > ./env3/env3-1.sh
    envar.reload
    # clean up pending paths (we still have
    # env4 there)
    envar.prune
    # unload the desk (aka exit current shell)
    exit
  "
}

__envar.help_deskless() {
  echo "TBD"
}

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
  local libdir="$(realpath "${file_dir}/..")"
  local main_content="$(cat "${libdir}/main.sh")"
  local funcname_escaped="$(sed 's/\./\\./g' <<< "${funcname}")"
  local func_lineno="$(
    grep -Pn '^s*export\s+\-f\s+'"${funcname_escaped}\$" <<< "${main_content}" \
    | cut -d: -f1
  )"

  local content_tac="$(head -n "$((func_lineno - 1))" <<< "${main_content}" | tac)"
  local end_line="$(grep -vn '^#' <<< "${content_tac}" | head -n 1 | cut -d: -f1)"
  local help_msg="$(
    head -n $((end_line - 1)) <<< "${content_tac}" \
    | tac | sed -E 's/^#(\s)?//g'
  )"
  [[ -n "${help_msg}" ]] && echo "${help_msg}"
}
