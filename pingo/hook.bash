__add_path_iife() {
  local projdir="$(dirname "$(realpath "${1}")")"
  export PINGO_PREPEND_PATH="${PINGO_PREPEND_PATH:-0}"
  export PINGO_BINDIR="${PINGO_BINDIR:-${projdir}/bin}"

  . "${projdir}/../.mix/bash.sh"
  __scriptbox_add_path --bindir "${PINGO_BINDIR}" \
    --prepend ${PINGO_PREPEND_PATH}
} && __add_path_iife "${1:-${BASH_SOURCE[0]}}"
unset __add_path_iife
