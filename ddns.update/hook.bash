__iife_hook() {
  local projdir="$(dirname "$(realpath "${1}")")"
  export DDNS_UPDATE_BINDIR="${DDNS_UPDATE_BINDIR:-${projdir}/bin}"

  . "${projdir}/../path/hook.bash"
  path.append "${DDNS_UPDATE_BINDIR}"
} && __iife_hook "${BASH_SOURCE[0]}"
unset __iife_hook
