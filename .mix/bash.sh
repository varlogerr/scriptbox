__scriptbox_add_path() {
  local bindir=""
  local prepend=0

  while :; do
    case "${1}" in
      --bindir)
        bindir="${2}"
        shift
        ;;
      --prepend)
        prepend="${2}"
        shift
        ;;
      *)
        # Default case: No more options, so break out of the loop.
        break
    esac
    shift
  done

  if : \
    && [[ -n "${bindir}" ]] \
    && ! tr ':' '\n' <<< "${PATH}" | sort | uniq \
      | grep -Fxq "${bindir}" \
  ; then
    # $bindir is not in the $PATH
    if [[ ${prepend} == 1 ]]; then
      # prepend $PATH with $bindir
      export PATH="${bindir}${PATH:+:${PATH}}"
    else
      # append ddns-update bin path to $PATH
      export PATH="${PATH:+${PATH}:}${bindir}"
    fi
  fi
}
