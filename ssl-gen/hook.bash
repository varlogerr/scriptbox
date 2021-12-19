__TMP_CURRENT_SRC="${1:-${BASH_SOURCE[0]}}"

. "$(dirname "${__TMP_CURRENT_SRC}")/../.mix/bash.sh"

export SSL_GEN_PREPEND_PATH="${SSL_GEN_PREPEND_PATH:-0}"
export SSL_GEN_BINDIR="${SSL_GEN_BINDIR:-$(
  script_path="$(realpath "${__TMP_CURRENT_SRC}")"
  script_dir="$(dirname "${script_path}")"
  echo "${script_dir}/bin"
)}"

scriptbox_add_path --bindir "${SSL_GEN_BINDIR}" \
  --prepend ${SSL_GEN_PREPEND_PATH}
