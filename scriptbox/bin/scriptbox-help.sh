#!/usr/bin/env bash

THE_SCRIPT="$(basename "${BASH_SOURCE[0]}")"
TOOL_DIR="$(realpath "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/..")"
BASE_DIR="$(realpath "${TOOL_DIR}/..")"

echo "Available tools:"

find "${BASE_DIR}" \
  -mindepth 1 -maxdepth 1 -type d \
    ! -path "${BASE_DIR}/.git" \
    ! -path "${BASE_DIR}/.mix" \
    ! -path "${TOOL_DIR}" \
| sort -n | while read -r d; do
  [[ ! -d "${d}/bin" ]] && continue
  
  printf '%-2s* %s\n' '' "$(basename "${d}")"
  printf '%-4s%s\n' '' 'Available commands (`--help` flag for help):'
  while read -r f; do
    [[ -n "${f}" ]] \
      && printf '%-6s* %s\n' '' "$(basename "${f}")"
  done <<< "$(
    find "${d}/bin" -mindepth 1 -maxdepth 1 \
      -type f -name '*.sh'
  )"
done
