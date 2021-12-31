if [[ -n "${BASH_VERSION}" ]]; then
  __iife_hook() {
    local projdir="$(dirname "$(realpath "${1}")")"
    . "${projdir}/lib/main.sh"
  } && __iife_hook "${BASH_SOURCE[0]}" && unset __iife_hook

  __envar.bootstrap
fi
