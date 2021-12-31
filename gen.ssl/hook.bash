__add_path_iife() {
  local projdir="$(dirname "$(realpath "${1}")")"
  export GEN_SSL_PREPEND_PATH="${GEN_SSL_PREPEND_PATH:-0}"
  export GEN_SSL_BINDIR="${GEN_SSL_BINDIR:-${projdir}/bin}"

  . "${projdir}/../.mix/bash.sh"
  __scriptbox_add_path --bindir "${GEN_SSL_BINDIR}" \
    --prepend ${GEN_SSL_PREPEND_PATH}
} && __add_path_iife "${1:-${BASH_SOURCE[0]}}"
unset __add_path_iife
