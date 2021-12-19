#!/usr/bin/env bash

THE_SCRIPT="${BASH_SOURCE[0]}"
THE_SCRIPT_NAME="$(basename "${THE_SCRIPT}")"
TOOL_DIR="$(realpath "$(dirname "$(realpath "${THE_SCRIPT}")")/..")"

COUNT=10
OUTPUT=/dev/stdout
INTERVAL=600
HOST=""

. "${TOOL_DIR}/help.sh"
. "${TOOL_DIR}/../.mix/bootstrap.sh"

while :; do
  case "${1}" in
    --count=?*)
      COUNT="${1#*=}"
      ;;
    -c|--count)
      COUNT="${2}"
      shift
      ;;
    --output=?*)
      OUTPUT="${1#*=}"
      ;;
    -o|--output)
      OUTPUT="${2}"
      shift
      ;;
    --interval=?*)
      INTERVAL="${1#*=}"
      ;;
    -i|--interval)
      INTERVAL="${2}"
      shift
      ;;
    ?*)
      HOST="${1}"
      ;;
    *)
      # Default case: No more options, so break out of the loop.
      break
  esac
  shift
done

if [[ -z "${HOST}" ]]; then
  echo "Error:"
  echo "  host is required!"
  echo
  print_help

  exit 1
fi

ctr=0; while :; do
  if [[ ${ctr} -gt 0 ]]; then
    echo
    echo '=========='
  fi
  (( ctr++ ))

  printf -- '[%s] Host: %s, Interval: %s, Count: %s\n' \
    "$(get_ts)" \
    "${HOST}" \
    "${INTERVAL}" \
    "${COUNT}"

  ping -c "${COUNT}" "${HOST}"

  [[ ${INTERVAL} -lt 1 ]] && break

  sleep "${INTERVAL}"
done >> "${OUTPUT}"
