__iife_hook() {
  local projdir="$(dirname "$(realpath "${1}")")"
  export SCRIPTBOX_BINDIR="${SCRIPTBOX_BINDIR:-${projdir}/bin}"

  . "${projdir}/../path/hook.bash"
  path.append "${SCRIPTBOX_BINDIR}"
} && __iife_hook "${BASH_SOURCE[0]}"
unset __iife_hook
