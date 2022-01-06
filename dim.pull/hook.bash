__iife_hook() {
  local projdir="$(dirname "$(realpath "${1}")")"
  export DIM_PULL_BINDIR="${DIM_PULL_BINDIR:-${projdir}/bin}"

  . "${projdir}/../path/hook.bash"
  path.append "${DIM_PULL_BINDIR}"
} && __iife_hook "${BASH_SOURCE[0]}"
unset __iife_hook
