# source tools hooks
while read -r l; do
  [[ -n "${l}" ]] && . "${l}"
done <<< "$(
  THE_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
  find "${THE_DIR}" \
    -mindepth 2 -maxdepth 2 \
    -type f -name 'hook.bash' \
    -not -path "${THE_DIR}/.*" \
  | sort -n
)"
