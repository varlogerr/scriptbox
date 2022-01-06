__iife_path() {
  local projdir="$(dirname "$(realpath "${1}")")"
  . "${projdir}/func/path.sh"
} && __iife_path "${BASH_SOURCE[0]}" && unset __iife_path

export -f path.append
export -f path.prepend
export -f path.ls
export -f __path.prepare_items
export -f __path.collect_items
export -f __path.rm_invalid_items
export -f __path.format_items
export -f __path.rm_existing_items
