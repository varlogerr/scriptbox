envar.source() {
  __envar.func_help "${FUNCNAME[0]}" "${@}" && return

  declare -A OPTS=(
    [deskless]=0
    [name]="${ENVAR_NAME}"
    [req_envs]=
    [pathfiles]=
    [gen_pathfile]=0
    [inval]=
  )
  __envar.parse_source_opts_to_global "${@}"
  __envar.fail_invalid_opts "${OPTS[inval]}" || return 1
  __envar.gen_pathfile "${OPTS[gen_pathfile]}" && return 0
  __envar.parse_pathfiles_to_global "${OPTS[pathfiles]}"
  OPTS[req_envs]="$(__envar.abspath "${OPTS[req_envs]}")"
  OPTS[req_envs]="$(__envar.merge "${ENVAR_REQ}" "${OPTS[req_envs]}")"

  OPTS[envs]="$(__envar.real "${OPTS[req_envs]}")"
  OPTS[env_files]="$(__envar.env_files "${OPTS[envs]}")"
  OPTS[hashed_files]="$(__envar.hash_files "${OPTS[env_files]}")"
  OPTS[all_files]="$(
    printf '%s\n%s' "${ENVAR_ALL_FILES}" "$(
      grep -vFx "${ENVAR_ALL_FILES}" <<< "${OPTS[env_files]}"
    )" | grep -vFx ''
  )"
  OPTS[stack]="@${OPTS[name]}${OPTS[all_files]:+$'\n'$(
    sed 's/^/#/g' <<< "${OPTS[all_files]}"
  )}"

  [[ ${OPTS[deskless]} -eq 0 ]] && {
    OPTS[stack]+="${ENVAR_STACK:+$'\n'${ENVAR_STACK}}"

    ENVAR_NAME="${OPTS[name]}" \
    ENVAR_REQ="${OPTS[req_envs]}" \
    ENVAR_ENVS="${OPTS[envs]}" \
    ENVAR_FILES="${OPTS[hashed_files]}" \
    ENVAR_ALL_FILES="${OPTS[all_files]}" \
    ENVAR_STACK="${OPTS[stack]}" \
    ENVAR_BASE_PS1="${ENVAR_BASE_PS1:-${PS1}}" bash
    return
  }

  local titles_lines="$(grep -n '^@' <<< "${ENVAR_STACK}" | cut -d: -f1)"
  if [[ $(wc -l <<< "${titles_lines}") -gt 1 ]]; then
    # we need to add newly added files to
    # latest stack block
    OPTS[stack]+=$'\n'"$(
      title2_line="$(head -n 2 <<< "${titles_lines}" | tail -n 1)"
      tail -n +$((title2_line)) <<< "${ENVAR_STACK}"
    )"
  fi

  export ENVAR_NAME="${OPTS[name]}"
  export ENVAR_REQ="${OPTS[req_envs]}"
  export ENVAR_ENVS="${OPTS[envs]}"
  export ENVAR_FILES="${OPTS[hashed_files]}"
  export ENVAR_ALL_FILES="${OPTS[all_files]}"
  export ENVAR_STACK="${OPTS[stack]}"
  export ENVAR_BASE_PS1="${ENVAR_BASE_PS1:-${PS1}}"

  __envar.bootstrap
}
# Source env paths. If a path is a directory
# all '*.sh' files will be loaded, for file
# paths extension doesn't matter
#
# Available options:
#   -D, --deskless (flag)
#     Run in deskless mode, i.e new bash process
#     won't be created
#   -f, --pathfile (multiple)
#     Read env paths list from a file. Empty
#     lines and lines starting with '#' are
#     ignored. Non-absolut paths are resolved
#     relatively to $PWD. Paths prefixed with
#     ':' are resolved relatively to pathfile
#     directory. Example:
#       # resolves to $PWD
#       ./envdir/envfile1.sh
#       # resolves to pathfile directory
#       :/envdir/envfile2.sh
#   --gen-pathfile (flag)
#     Generate pathfile dummy to stdout
#   -n, --name
#     Name for the environment
#   --
#     End of options
export -f envar.source

envar.status() {
  __envar.func_help "${FUNCNAME[0]}" "${@}" && return

  [[ -z "${ENVAR_REQ}" ]] && return

  local path="$(__envar.real "${ENVAR_REQ}")"
  local files="$(__envar.env_files "${path}" | __envar.hash_files)"
  [[ (-z "${path}" && -z "${files}") ]] && return

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
# Print current environment files
# status
#
# Statuses:
#   * - changed file
#   - - removed file
#   + - addeds file
export -f envar.status

envar.req() {
  __envar.func_help "${FUNCNAME[0]}" "${@}" && return

  [[ -n "${ENVAR_REQ}" ]] && echo "${ENVAR_REQ}"
}
# List all env paths requested
# by user
export -f envar.req

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
    grep --color=never '^@' <<< "${entries}"
    return
  }

  echo "${entries}"
}
# Print environments stack
#
# Available options:
#   -c, --count
#       Entries count
#   -v, --verbose (flag)
#       Print with sourced files.
#       Will show all files, that
#       has been sourced during
#       the session (including
#       removed ones)
export -f envar.stack

envar.reload() {
  __envar.func_help "${FUNCNAME[0]}" "${@}" && return

  [[ -n "${ENVAR_REQ}" ]] && envar.source -D
}
# Reload env paths. This will
# reload sourced env paths and
# pending ones if they got created
export -f envar.reload

envar.pending() {
  __envar.func_help "${FUNCNAME[0]}" "${@}" && return

  grep -vFx -e "${ENVAR_ENVS}" <<< "${ENVAR_REQ}"
}
# List pending env paths
export -f envar.pending

envar.prune() {
  __envar.func_help "${FUNCNAME[0]}" "${@}" && return

  [[ -n "${ENVAR_REQ+x}" ]] && ENVAR_REQ="${ENVAR_ENVS}"
}
# Prune pending env paths
export -f envar.prune

envar.ls() {
  __envar.func_help "${FUNCNAME[0]}" "${@}" && return

  [[ -n "${ENVAR_ENVS}" ]] && echo "${ENVAR_ENVS}"
}
# List currently loaded env paths
export -f envar.ls

envar.files() {
  __envar.func_help "${FUNCNAME[0]}" "${@}" && return

  [[ -z "${ENVAR_FILES}" ]] && return

  cut -d: -f2- <<< "${ENVAR_FILES}"
}
# List existing loaded files
export -f envar.files

envar.help() {
  __envar.func_help "${FUNCNAME[0]}" "${@}" && return

  while :; do
    [[ -z "${1+x}" ]] && break

    case "${1}" in
      --demo)     __envar.help_demo; return ;;
    esac

    shift
  done

  __envar.help_main
}
# Print help
#
# Available options:
#   --desk      Print desk usage
#   --deskless  Print deskless usage
export -f envar.help

__envar.bootstrap() {
  [[ (-n "${ENVAR_BASE_PS1}" && -n "${ENVAR_NAME}") ]] \
    && export PS1="${ENVAR_BASE_PS1}@${ENVAR_NAME} > "

  while read -r f; do
    [[ -z "${f}" ]] && continue
    . "${f}"
  done <<< "$(envar.files)"
}
export -f __envar.bootstrap
