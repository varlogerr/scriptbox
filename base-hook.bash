if [[ -n "${BASH_VERSION}" ]]; then
  __iife_base_hook() {
    local basedir="$(dirname "$(realpath "${1}")")"

    . "${basedir}/path/hook.bash"
    . "${basedir}/envar/hook.bash"
  } && __iife_base_hook "${BASH_SOURCE[0]}" && unset __iife_base_hook
fi
