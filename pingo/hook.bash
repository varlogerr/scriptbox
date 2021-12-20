__add_path_iife() {
  local current_src="${1}"
  export PINGO_PREPEND_PATH="${PINGO_PREPEND_PATH:-0}"
  export PINGO_BINDIR="${PINGO_BINDIR:-$(
    script_path="$(realpath "${current_src}")"
    script_dir="$(dirname "${script_path}")"
    echo "${script_dir}/bin"
  )}"

  . "$(dirname "${current_src}")/../.mix/bash.sh"
  __scriptbox_add_path --bindir "${PINGO_BINDIR}" \
    --prepend ${PINGO_PREPEND_PATH}
} && __add_path_iife "${1:-${BASH_SOURCE[0]}}"
unset __add_path_iife
