#!/usr/bin/env bash

THE_SCRIPT="${BASH_SOURCE[0]}"
THE_SCRIPT_NAME="$(basename "${THE_SCRIPT}")"
TOOL_DIR="$(realpath "$(dirname "$(realpath "${THE_SCRIPT}")")/..")"

SRC_DIR="${TOOL_DIR}/src"

. "${TOOL_DIR}/help.sh"
. "${TOOL_DIR}/../.mix/bootstrap.sh"

get_types() {
  find "${SRC_DIR}" -mindepth 1 -maxdepth 1 -type f \
  | while read -r f; do basename "${f}"; done
}

if grep -qP -- '^(-l|--list)$' <<< "${1}"; then
  get_types
  exit
fi

THE_TYPE="${1}"
THE_FILE="${SRC_DIR}/${THE_TYPE}"

if [[ ! -f "${THE_FILE}" ]]; then
  echo "'${THE_TYPE}' is not a supported type!" >&2
  echo
  echo "Supported types:"
  get_types | while read -r l; do
    echo "  ${l}"
  done
  exit
fi

cat "${THE_FILE}"
