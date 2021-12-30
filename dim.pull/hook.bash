__add_path_iife() {
  local projdir="$(dirname "$(realpath "${1}")")"
  export DIM_PULLER_PREPEND_PATH="${DIM_PULLER_PREPEND_PATH:-0}"
  export DIM_PULLER_BINDIR="${DIM_PULLER_BINDIR:-${projdir}/bin}"

  . "${projdir}/../.mix/bash.sh"
  __scriptbox_add_path --bindir "${DIM_PULLER_BINDIR}" \
    --prepend ${DIM_PULLER_PREPEND_PATH}
} && __add_path_iife "${1:-${BASH_SOURCE[0]}}"
unset __add_path_iife
