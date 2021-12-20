__TMP_CURRENT_SRC="${1:-${BASH_SOURCE[0]}}"

. "$(dirname "${__TMP_CURRENT_SRC}")/../.mix/bash.sh"

export SCRIPTBOX_PREPEND_PATH="${SCRIPTBOX_PREPEND_PATH:-0}"
export SCRIPTBOX_BINDIR="${SCRIPTBOX_BINDIR:-$(
  script_path="$(realpath "${__TMP_CURRENT_SRC}")"
  script_dir="$(dirname "${script_path}")"
  echo "${script_dir}/bin"
)}"

scriptbox_add_path --bindir "${SCRIPTBOX_BINDIR}" \
  --prepend ${SCRIPTBOX_PREPEND_PATH}
