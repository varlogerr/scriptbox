declare -A required_envs=(
  [DDNS_USER]='dynu ydns'
  [DDNS_PASS]='duckdns dynu ydns'
  [DDNS_HOSTS]='duckdns ydns'
)

missing_envs=()
for k in "${!required_envs[@]}"; do
  provs="${required_envs[${k}]}"

  ! grep -Fq " ${DDNS_PROVIDER} " <<< " ${provs} " && continue

  [[ -z "${!k}" ]] && missing_envs+=("${k}")
done

if [[ ${#missing_envs[@]} -gt 0 ]]; then
  echo "Missing required options for '${DDNS_PROVIDER}' provider:"
  for e in "${missing_envs[@]}"; do
    echo "  * ${e}"
  done
  echo "See \`${THE_SCRIPT} --help\`"

  exit 1
fi
