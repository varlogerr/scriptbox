__iife_hook() {
  local projdir="$(dirname "$(realpath "${1}")")"
  export GEN_SSL_BINDIR="${GEN_SSL_BINDIR:-${projdir}/bin}"

  . "${projdir}/../path/hook.bash"
  path.append "${GEN_SSL_BINDIR}"
} && __iife_hook "${BASH_SOURCE[0]}"
unset __iife_hook
