path.append() {
  local items="$(__path.prepare_items "${@}")"

  [[ -n "${items}" ]] && {
    export PATH="${PATH:+${PATH}:}${items}"
  }
}

path.prepend() {
  local items="$(__path.prepare_items "${@}")"

  [[ -n "${items}" ]] && {
    export PATH="${items}${PATH:+:${PATH}}"
  }
}

path.ls() {
  [[ -n "${PATH}" ]] && tr ':' '\n' <<< "${PATH}"
}

__path.prepare_items() {
  local items="$(__path.collect_items "${@}")"
  items="$(__path.rm_invalid_items "${items}")"
  items="$(__path.rm_existing_items "${items}")"
  __path.format_items "${items}"
}

__path.collect_items() {
  while :; do
    [[ -z "${1+x}" ]] && break
    [[ -z "${1}" ]] && shift && continue

    echo "${1}"
    shift
  done
}

__path.rm_invalid_items() {
  grep -v ':' <<< "${1}"
}

__path.format_items() {
  printf '%s' "${1}" | tr '\n' ':'
}

__path.rm_existing_items() {
  local path_lines="$(path.ls)"
  grep -vFx "${path_lines}" <<< "${1}"
}
