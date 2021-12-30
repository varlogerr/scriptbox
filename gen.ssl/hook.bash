__add_path_iife() {
  local projdir="$(dirname "$(realpath "${1}")")"
  export SSL_GEN_PREPEND_PATH="${SSL_GEN_PREPEND_PATH:-0}"
  export SSL_GEN_BINDIR="${SSL_GEN_BINDIR:-${projdir}/bin}"

  . "${projdir}/../.mix/bash.sh"
  __scriptbox_add_path --bindir "${SSL_GEN_BINDIR}" \
    --prepend ${SSL_GEN_PREPEND_PATH}
} && __add_path_iife "${1:-${BASH_SOURCE[0]}}"
unset __add_path_iife
