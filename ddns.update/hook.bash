__add_path_iife() {
  local projdir="$(dirname "$(realpath "${1}")")"
  export DDNS_UPDATE_PREPEND_PATH="${DDNS_UPDATE_PREPEND_PATH:-0}"
  export DDNS_UPDATE_BINDIR="${DDNS_UPDATE_BINDIR:-${projdir}/bin}"

  . "${projdir}/../.mix/bash.sh"
  __scriptbox_add_path --bindir "${DDNS_UPDATE_BINDIR}" \
    --prepend ${DDNS_UPDATE_PREPEND_PATH}
} && __add_path_iife "${1:-${BASH_SOURCE[0]}}"
unset __add_path_iife
