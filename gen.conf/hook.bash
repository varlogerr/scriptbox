__add_path_iife() {
  local current_src="${1}"
  export GENCONF_PREPEND_PATH="${GENCONF_PREPEND_PATH:-0}"
  export GENCONF_BINDIR="${GENCONF_BINDIR:-$(
    script_path="$(realpath "${current_src}")"
    script_dir="$(dirname "${script_path}")"
    echo "${script_dir}/bin"
  )}"

  . "$(dirname "${current_src}")/../.mix/bash.sh"
  __scriptbox_add_path --bindir "${GENCONF_BINDIR}" \
    --prepend ${GENCONF_PREPEND_PATH}
} && __add_path_iife "${1:-${BASH_SOURCE[0]}}"
unset __add_path_iife
