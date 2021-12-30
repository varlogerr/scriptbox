__add_path_iife() {
  local projdir="$(dirname "$(realpath "${1}")")"
  export GENCONF_PREPEND_PATH="${GENCONF_PREPEND_PATH:-0}"
  export GENCONF_BINDIR="${GENCONF_BINDIR:-${projdir}/bin}"

  . "${projdir}/../.mix/bash.sh"
  __scriptbox_add_path --bindir "${GENCONF_BINDIR}" \
    --prepend ${GENCONF_PREPEND_PATH}
} && __add_path_iife "${1:-${BASH_SOURCE[0]}}"
unset __add_path_iife
