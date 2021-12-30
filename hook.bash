# source tools hooks
while read -r l; do
  [[ -n "${l}" ]] && . "${l}"
done <<< "$(
  THE_DIR="$(dirname "$(realpath "${1:-${BASH_SOURCE[0]}}")")"
  find "${THE_DIR}" \
    -mindepth 2 -maxdepth 2 \
    -type f -name 'hook.bash' \
    -not -path "${THE_DIR}/"'\.git/*' \
    -not -path "${THE_DIR}/"'\.mix/*' \
  | sort -n
)"
