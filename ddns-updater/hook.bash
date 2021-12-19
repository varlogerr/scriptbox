__TMP_CURRENT_SRC="${1:-${BASH_SOURCE[0]}}"

. "$(dirname "${__TMP_CURRENT_SRC}")/../.mix/bash.sh"

export DDNS_UPDATER_PREPEND_PATH="${DDNS_UPDATER_PREPEND_PATH:-0}"
export DDNS_UPDATER_BINDIR="${DDNS_UPDATER_BINDIR:-$(
  script_path="$(realpath "${__TMP_CURRENT_SRC}")"
  script_dir="$(dirname "${script_path}")"
  echo "${script_dir}/bin"
)}"

scriptbox_add_path --bindir "${DDNS_UPDATER_BINDIR}" \
  --prepend ${DDNS_UPDATER_PREPEND_PATH}
