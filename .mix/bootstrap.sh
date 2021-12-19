CORE_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

opt_n=1
while :; do
  [[ -z "${!opt_n+x}" ]] && break

  opt="${!opt_n}"
  if : \
    && grep -Pxq -- '-h|-\?|--help' <<< "${opt}" \
    && [[ "$(type -t print_help)" == 'function' ]] \
  ; then
    print_help
    exit
  elif : \
    && grep -Pxq -- '--long-help' <<< "${opt}" \
    && [[ "$(type -t print_help_long)" == 'function' ]] \
  ; then
    print_help_long
    exit
  elif : \
    && grep -Pxq -- '--short-help' <<< "${opt}" \
    && [[ "$(type -t print_help_short)" == 'function' ]] \
  ; then
    print_help_short
    exit
  fi

  (( opt_n++ ))
done
