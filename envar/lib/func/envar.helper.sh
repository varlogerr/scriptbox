__envar.parse_source_opts_to_global() {
  local eopt=0
  local opt

  while :; do
    # break on end of params
    [[ -z "${1+x}" ]] && break

    opt="${1}"
    shift

    grep -qx '\s*' <<< "${opt}" && continue

    # add path
    [[ ${eopt} == 1 ]] || [[ ${opt:0:1} != '-' ]] && {
      OPTS[req_envs]+="${OPTS[req_envs]:+$'\n'}${opt}"
      continue
    }

    # parse options
    case "${opt}" in
      -D|--deskless)
        OPTS[deskless]=1
        ;;
      --name=*)
        OPTS[name]="${opt#*=}"
        ;;
      -n|--name)
        OPTS[name]="${1}"
        shift
        ;;
      --pathfile=*)
        OPTS[pathfiles]+="${OPTS[pathfiles]:+$'\n'}${opt#*=}"
        ;;
      -f|--pathfile)
        OPTS[pathfiles]+="${OPTS[pathfiles]:+$'\n'}${1}"
        shift
        ;;
      --gen-pathfile)
        OPTS[gen_pathfile]=1
        ;;
      --)
        eopt=1
        ;;
      *)
        OPTS[inval]+="${OPTS[inval]:+$'\n'}${opt}"
        ;;
    esac
  done
}
export -f __envar.parse_source_opts_to_global

__envar.fail_invalid_opts() {
  [[ -n "${1}" ]] && {
    echo "Invalid options:"
    while read -r o; do
      printf -- '%-2s%s\n' '' "${o}" >&2
    done <<< "${1}"
    return 1
  }
  return 0
}
export -f __envar.fail_invalid_opts

__envar.gen_pathfile() {
  [[ ${1} -ne 1 ]] && return 1

  local assetsdir="$(
    dirname "${BASH_SOURCE[0]}"
  )/../assets"

  grep -vFx '' "${assetsdir}/pathfile.sh" \
  | sed 's/^/# /g'
  return 0
}
export -f __envar.gen_pathfile

__envar.merge() {
  local old="${1}"
  local new="${2}"
  local to_add="$(grep -vFx "${old}" <<< "${new}")"

  [[ -n "${to_add}" ]] && {
    echo "${old:+${old}$'\n'}${to_add}"
    return
  }

  [[ -n "${old}" ]] && echo "${old}"
}
export -f __envar.merge

__envar.parse_pathfiles_to_global() {
  local content="$( while read -r pathfile; do
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
  done <<< "${1}" | grep -vFx '' )"

  [[ -n "${content}" ]] && {
    OPTS[req_envs]+="${OPTS[req_envs]:+$'\n'}${content}"
  }
}
export -f __envar.parse_pathfiles_to_global

__envar.abspath() {
  local inp="${1}"
  [[ -p /dev/stdin ]] && inp="$(cat -)"

  while read -r p; do
    realpath -qms -- "${p}"
  done <<< "${inp}"
}
export -f __envar.abspath

__envar.uniq() {
  local inp="${1}"
  [[ -p /dev/stdin ]] && inp="$(cat -)"

  # grabbed from here:
  # https://unix.stackexchange.com/questions/194780/remove-duplicate-lines-while-keeping-the-order-of-the-lines
  tac <<< "${inp}" | cat -n | sort -k2 -k1n \
  | uniq -f1 | sort -nk1,1 | cut -f2- | tac
}
export -f __envar.uniq

__envar.real() {
  local inp="${1}"
  [[ -p /dev/stdin ]] && inp="$(cat -)"

  while read -r p; do
    [[ -z "${p}" ]] && continue
    [[ -d "${p}" || -f "${p}" ]] && echo "${p}"
  done <<< "${inp}"
}
export -f __envar.real

__envar.env_files() {
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
export -f __envar.env_files

__envar.hash_files() {
  local inp="${1}"
  [[ -p /dev/stdin ]] && inp="$(cat -)"

  local chsum
  while read -r f; do
    [[ (-z "${f}" || ! -f "${f}") ]] && continue

    chsum="$(sha1sum "$(realpath "${f}")" | cut -d' ' -f 1)"
    echo "${chsum}:${f}"
  done <<< "${inp}"
}
export -f __envar.hash_files
