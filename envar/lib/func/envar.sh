envar.source() {
  __envar.func_help "${FUNCNAME[0]}" "${@}" && return

  local deskless=0
  local name="${ENVAR_NAME}"
  local req_path="${ENVAR_REQ}"
  local path
  local files
  local pathfiles
  local gen_pathfile=0

  # parse params
  local eopt=0
  local opt_n=0
  local inval
  while :; do
    (( opt_n++ ))
    opt="${!opt_n}"
    # break on end of params and skip empty params
    [[ -z "${!opt_n+x}" ]] && break
    grep -qx '\s*' <<< "${!opt_n}" && continue

    # add path
    [[ ${eopt} == 1 ]] || [[ ${opt:0:1} != '-' ]] && {
      req_path="${req_path:+${req_path}$'\n'}${opt}"
      continue
    }

    # parse options
    case "${opt}" in
      -D|--deskless)  deskless=1 ;;
      --name=?*)      name="${opt#*=}" ;;
      -n|--name)      (( opt_n++ )); name="${!opt_n}" ;;
      --pathfile=?*)  pathfiles="${pathfiles:+${pathfiles}$'\n'}${opt#*=}" ;;
      -f|--pathfile)  (( opt_n++ )); pathfiles="${pathfiles:+${pathfiles}$'\n'}${!opt_n}" ;;
      --gen-pathfile) gen_pathfile=1 ;;
      --)             eopt=1 ;;
      *)              inval="${inval:+${inval}$'\n'}${opt}" ;;
    esac
  done

  __envar.validate_options "${inval}" || return 1
  __envar.gen_pathfile ${gen_pathfile} && return 0

  local pathfiles_content="$(__envar.parse_pathfiles "${pathfiles}")"

  req_path="$(
    printf '%s\n%s' "${req_path}" "${pathfiles_content}" \
    | grep -vFx ''
  )"

  # unique abspath for requested path
  req_path="$( while read -r p; do
    realpath -qms -- "${p}"
  done <<< "${req_path}"  | __envar.uniq )"

  # put existing path
  path="$(__envar.real "${req_path}")"
  # collect files to source
  # and prepend them with checksum
  files="$(__envar.path_files "${path}")"
  local hashed_files="$(__envar.checksum_files "${files}")"

  [[ ${deskless} -eq 0 ]] && {
    local stack="@${name:-(anonymous)}"
    stack+="${files:+$'\n'$(sed 's/^/#/g' <<< "${files}")}"
    stack+="${ENVAR_STACK:+$'\n'${ENVAR_STACK}}"

    ENVAR_NAME="${name}" \
    ENVAR_REQ="${req_path}" \
    ENVAR_PATH="${path}" \
    ENVAR_FILES="${hashed_files}" \
    ENVAR_BASE_PS1="${ENVAR_BASE_PS1:-${PS1}}" \
    ENVAR_STACK="${stack}" bash
    return
  }

  # we need to add newly added files to
  # latest stack block
  [[ -n "${ENVAR_STACK}" ]] && {
    local head_len="$(envar.stack -v -c 1 | wc -l)"
    local stack_tail="$(tail -n +$((head_len + 1)) <<< "${ENVAR_STACK}")"
    local head_files="$(envar.files)"
    local new_files="$(grep -vFx -e "${head_files}" <<< "${files}")"

    [[ (-n "${head_files}" && -n "${new_files}") ]] && head_files+=$'\n'
    head_files+="${new_files}"

    local new_stack="@${name}"
    new_stack+="${head_files:+$'\n'$(sed 's/^/#/g' <<< "${head_files}")}"
    new_stack+="${stack_tail:+$'\n'${stack_tail}}"

    export ENVAR_STACK="${new_stack}"
  }

  export ENVAR_NAME="${name}"
  export ENVAR_REQ="${req_path}"
  export ENVAR_PATH="${path}"
  export ENVAR_FILES="${hashed_files}"
  export ENVAR_BASE_PS1="${ENVAR_BASE_PS1:-${PS1}}"

  __envar.bootstrap
}

envar.status() {
  __envar.func_help "${FUNCNAME[0]}" "${@}" && return

  [[ -z "${ENVAR_REQ}" ]] && return

  # put existing path
  local path="$(__envar.real "${ENVAR_REQ}")"
  # collect unique files to source
  local files="$(__envar.path_files "${path}" | __envar.checksum_files)"
  # {new_hash}:{file}
  local res1="$(
    join -t: -j1 1 -j2 2 -a 1 -o2.1,1.1 \
      <(cat \
        <(cut -d: -f2- <<< "${files}") \
        <(envar.files) \
        | sort | uniq) \
      <(sort -t: -k2 <<< "${files}")
  )"
  # {old_hash}:{new_hash}:{file}
  local res2="$(
    join -t: -j1 2 -j2 2 -a 1 -o1.1,2.1,1.2 \
      <(echo "${res1}") \
      <(sort -t: -k2 <<< "${ENVAR_FILES}")
  )"

  local init_hash
  local current_hash
  local file
  while read -r f; do
    [[ -z "${f}" ]] && continue

    init_hash="$(cut -d: -f2 <<< "${f}")"
    current_hash="$(cut -d: -f1 <<< "${f}")"
    file="$(cut -d: -f3 <<< "${f}")"

    [[ -z "${init_hash}" ]] && {
      printf -- '%-2s%s\n' '+' "${file}"
      continue
    }

    [[ -z "${current_hash}" ]] && {
      printf -- '%-2s%s\n' '-' "${file}"
      continue
    }

    [[ "${current_hash}" != "${init_hash}" ]] && {
      printf -- '%-2s%s\n' '*' "${file}"
      continue
    }

    printf -- '%-2s%s\n' ' ' "${file}"
  done <<< "${res2}"
}

envar.req() {
  __envar.func_help "${FUNCNAME[0]}" "${@}" && return

  [[ -n "${ENVAR_REQ}" ]] && echo "${ENVAR_REQ}"
}

envar.stack() {
  __envar.func_help "${FUNCNAME[0]}" "${@}" && return

  [[ -z "${ENVAR_STACK}" ]] && return

  local verbose=0
  local count=0
  while :; do
    [[ -z "${1+x}" ]] && break

    case "${1}" in
      -v|--verbose)   verbose=1 ;;
      --count=?*)     count="${1#*=}" ;;
      -c|--count)     shift; count="${1}" ;;
      *)              ;;
    esac

    shift
  done
  grep -vqP '^\d+$' <<< "${count}" && count=0

  local entries_lines_nums="$(grep -n '^@' <<< "${ENVAR_STACK}" | cut -d: -f1)"
  local entries_count="$(wc -l <<< "${entries_lines_nums}")"
  local entries="$(sed 's/^#/  /g' <<< ${ENVAR_STACK})"
  [[ (${count} -ne 0 && ${count} -lt ${entries_count}) ]] && {
    local last_line_num="$(
      head -n $((count + 1)) \
        <<< "${entries_lines_nums}" | tail -n 1
    )"
    entries="$(head -n $((last_line_num - 1)) <<< "${entries}")"
  }

  [[ ${verbose} -eq 0 ]] && {
    grep '^@' <<< "${entries}" | sed 's/^@//g'
    return
  }

  sed 's/^@//g' <<< "${entries}"
}

envar.reload() {
  __envar.func_help "${FUNCNAME[0]}" "${@}" && return

  [[ -n "${ENVAR_REQ}" ]] && envar.source -D
}

envar.pending() {
  __envar.func_help "${FUNCNAME[0]}" "${@}" && return

  local pending="$(grep -vFx -e "${ENVAR_PATH}" <<< "${ENVAR_REQ}")"
  [[ -n "${pending}" ]] && echo "${pending}"
}

envar.prune() {
  __envar.func_help "${FUNCNAME[0]}" "${@}" && return

  [[ -n "${ENVAR_REQ+x}" ]] && ENVAR_REQ="${ENVAR_PATH}"
}

envar.path() {
  __envar.func_help "${FUNCNAME[0]}" "${@}" && return

  [[ -n "${ENVAR_PATH}" ]] && echo "${ENVAR_PATH}"
}

envar.files() {
  __envar.func_help "${FUNCNAME[0]}" "${@}" && return

  [[ -z "${ENVAR_FILES}" ]] && return

  cut -d: -f2- <<< "${ENVAR_FILES}"
}

__envar.uniq() {
  # grabbed from here:
  # https://unix.stackexchange.com/questions/194780/remove-duplicate-lines-while-keeping-the-order-of-the-lines
  local inp="${1}"
  [[ -p /dev/stdin ]] && inp="$(cat -)"

  tac <<< "${inp}" | cat -n | sort -k2 -k1n \
  | uniq -f1 | sort -nk1,1 | cut -f2- | tac
}

__envar.real() {
  local inp="${1}"
  [[ -p /dev/stdin ]] && inp="$(cat -)"

  while read -r p; do
    [[ -z "${p}" ]] && continue
    [[ -d "${p}" || -f "${p}" ]] && echo "${p}"
  done <<< "${inp}"
}

__envar.path_files() {
  local inp="${1}"
  [[ -p /dev/stdin ]] && inp="$(cat -)"

  local fp
  while read -r p; do
    [[ -z "${p}" ]] && continue

    [[ -f "${p}" ]] && fp="${p}" \
      || fp="$(find -L "${p}" -type f -name "*.sh" | sort -n)"

    echo "${fp}"
  done <<< "${1}"
}

__envar.checksum_files() {
  local inp="${1}"
  [[ -p /dev/stdin ]] && inp="$(cat -)"

  local chsum
  while read -r f; do
    [[ -z "${f}" ]] && continue

    if [[ (-z "${f}" || ! -f "${f}") ]]; then
      echo "${FUNCNAME[0]}: '${f}' is not a file!" >&2
      return 1
    fi

    chsum="$(sha1sum "$(realpath "${f}")" | cut -d' ' -f 1)"
    echo "${chsum}:${f}"
  done <<< "${inp}"
}

__envar.bootstrap() {
  [[ (-n "${ENVAR_BASE_PS1}" && -n "${ENVAR_NAME}") ]] \
    && export PS1="${ENVAR_BASE_PS1}@${ENVAR_NAME} > "

  while read -r f; do
    [[ -z "${f}" ]] && continue
    . "${f}"
  done <<< "$(envar.files)"
}

__envar.validate_options() {
  [[ -n "${inval}" ]] && {
    echo "Invalid options:"
    while read -r o; do
      printf -- '%-2s%s\n' '' "${o}" >&2
    done <<< "${inval}"
    return 1
  }
  return 0
}

__envar.gen_pathfile() {
  [[ ${1} -ne 1 ]] && return 1

  while read -r l; do
    [[ -n "${l}" ]] && echo "# ${l}"
  done <<< "
    # absolute paths are resolved normally
    /path/to/env-path
    # prefixed with ':' resolved to pathfile
    # directory. The following will be resolved
    # to \$(dirname \$(realpath </path/to/pathfile>)
    :relative/path/to/env-path
    # relative paths are resolved to \$PWD
    relative/path/to/env-path
  "
  return 0
}

__envar.parse_pathfiles() {
  while read -r pathfile; do
    [[ -z "${pathfile}" ]] && continue
    [[ ! -f "${pathfile}" ]] && continue

    # exclude empty lines and lines
    # starting with '#'
    grep -v '^#' "${pathfile}" | grep -vFx '' \
    | while read -r envrile; do
      [[ "${envrile:0:1}" != ':' ]] && {
        echo "${envrile}"
        continue
      }

      local pathfile_dir="$(dirname "$(realpath -qms "${pathfile}")")"
      echo "${pathfile_dir}/${envrile:1}"
    done
  done <<< "${1}"
}
