__add_path_iife() {
  local current_src="${1}"
  export SSL_GEN_PREPEND_PATH="${SSL_GEN_PREPEND_PATH:-0}"
  export SSL_GEN_BINDIR="${SSL_GEN_BINDIR:-$(
    script_path="$(realpath "${current_src}")"
    script_dir="$(dirname "${script_path}")"
    echo "${script_dir}/bin"
  )}"

  . "$(dirname "${current_src}")/../.mix/bash.sh"
  __scriptbox_add_path --bindir "${SSL_GEN_BINDIR}" \
    --prepend ${SSL_GEN_PREPEND_PATH}
} && __add_path_iife "${1:-${BASH_SOURCE[0]}}"
unset __add_path_iife
