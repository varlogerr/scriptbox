__add_path_iife() {
  local projdir="$(dirname "$(realpath "${1}")")"
  export SCRIPTBOX_PREPEND_PATH="${SCRIPTBOX_PREPEND_PATH:-0}"
  export SCRIPTBOX_BINDIR="${SCRIPTBOX_BINDIR:-${projdir}/bin}"

  . "${projdir}/../.mix/bash.sh"
  __scriptbox_add_path --bindir "${SCRIPTBOX_BINDIR}" \
    --prepend ${SCRIPTBOX_PREPEND_PATH}
} && __add_path_iife "${1:-${BASH_SOURCE[0]}}"
unset __add_path_iife
