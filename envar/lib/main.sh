__iife_envar() {
  local funcdir="$(dirname "$(realpath "${1}")")/func"
  . "${funcdir}/envar.helper.sh"
  . "${funcdir}/envar.sh"
  . "${funcdir}/help.sh"
} && __iife_envar "${BASH_SOURCE[0]}" && unset __iife_envar
