__iife_hook() {
  local projdir="$(dirname "$(realpath "${1}")")"
  export PINGO_BINDIR="${PINGO_BINDIR:-${projdir}/bin}"

  . "${projdir}/../path/hook.bash"
  path.append "${PINGO_BINDIR}"
} && __iife_hook "${BASH_SOURCE[0]}"
unset __iife_hook
