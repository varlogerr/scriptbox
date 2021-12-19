__TMP_CURRENT_SRC="${1:-${BASH_SOURCE[0]}}"

. "$(dirname "${__TMP_CURRENT_SRC}")/../.mix/bash.sh"

export PINGO_PREPEND_PATH="${PINGO_PREPEND_PATH:-0}"
export PINGO_BINDIR="${PINGO_BINDIR:-$(
  script_path="$(realpath "${__TMP_CURRENT_SRC}")"
  script_dir="$(dirname "${script_path}")"
  echo "${script_dir}/bin"
)}"

scriptbox_add_path --bindir "${PINGO_BINDIR}" \
  --prepend ${PINGO_PREPEND_PATH}
