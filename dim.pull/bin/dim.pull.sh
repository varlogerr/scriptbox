#!/usr/bin/env bash

THE_SCRIPT="${BASH_SOURCE[0]}"
THE_SCRIPT_NAME="$(basename "${THE_SCRIPT}")"
TOOL_DIR="$(realpath "$(dirname "$(realpath "${THE_SCRIPT}")")/..")"

page_size=1

. "${TOOL_DIR}/help.sh"
. "${TOOL_DIR}/../.mix/bootstrap.sh"

OPTS=()

listfiles=()
imgs=''
remove=0

# detect listfiles
opt_n=1; while :; do
  [[ -z "${!opt_n+x}" ]] && break
  opt="${!opt_n}"

  case "${opt}" in
    --listfile=?*)
      listfiles+=("${!opt_n#*=}")
      ;;
    -f|--listfile)
      (( opt_n++ ))
      listfiles+=("${!opt_n}")
      ;;
    *)
      OPTS+=("${opt}")
      ;;
  esac

  (( opt_n++ ))
done

for f in "${listfiles[@]}"; do
  if [[ ! -f "${f}" ]]; then
    echo "Listfile '${f}' file not found!" >&2
    continue
  fi

  # parse listfile
  [[ -n "${imgs}" ]] && imgs+=$'\n'
  imgs+="$(while read -r i; do
    [[ "${i:0:1}" == '#' ]] && continue
    [[ -n "${i}" ]] && echo "${i}"
  done < "${f}")"
done

# parse the rest of the options
opt_n=1; while :; do
  [[ -z "${!opt_n+x}" ]] && break
  opt="${!opt_n}"

  case "${opt}" in
    --limit=?*)
      page_size="${!opt_n#*=}"
      ;;
    -l|--limit)
      (( opt_n++ ))
      page_size="${!opt_n}"
      ;;
    -r|--remove)
      remove=1
      ;;
    *)
      [[ -n "${imgs}" ]] && imgs+=$'\n'
      imgs+="${opt}"
      ;;
  esac

  (( opt_n++ ))
done

while read -r img_name; do
  [[ -z "${img_name}" ]] && continue

  tags_url=https://registry.hub.docker.com/v2/repositories/${img_name}/tags?page_size=${page_size}
  if ! grep -q '\/' <<< "${img_name}"; then
    tags_url=https://hub.docker.com/v2/repositories/library/${img_name}/tags?page_size=${page_size}
  fi

  tags="$(
    curl -s "${tags_url}" 2> /dev/null \
    | grep -Po '"name"\s*:\s*"[^"]+"' \
    | sed -E 's/.*:\s*"([^"]+)"$/\1/g'
  )"

  if [[ -z "${tags}" ]]; then
    echo "No tags found for '${img_name}'" >&2
    continue
  fi

  existing_imgs="$(
    docker image ls -f reference="${img_name}" \
      --format '{{ .Repository }}:{{ .Tag }}'
  )"

  for t in ${tags}; do
    img="${img_name}:${t}"
    img_exists=0
    if grep -Fxq "${img}" <<< "${existing_imgs}"; then
      img_exists=1
    fi

    docker image pull "${img}"

    [[ ${img_exists} -eq 0 ]] \
    && [[ ${remove} -eq 1 ]] \
    && docker image rm "${img}"
  done
done <<< "${imgs}"
