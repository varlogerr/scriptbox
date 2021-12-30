# source specific help functions
. "${TOOL_DIR}/help/${DDNS_PROVIDER}.sh"
# source common help functions
. "${TOOL_DIR}/help/common.sh"
. "${TOOL_DIR}/../.mix/func.sh"
. "${TOOL_DIR}/../.mix/bootstrap.sh"
. "${TOOL_DIR}/func.sh"
# source options parser
. "${TOOL_DIR}/opts/${DDNS_PROVIDER}.sh"
# validate options
. "${TOOL_DIR}/validator.sh"
