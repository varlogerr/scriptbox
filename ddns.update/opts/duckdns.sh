# parse opts
opt_n=1; while :; do
  [[ -z "${!opt_n+x}" ]] && break
  opt="${!opt_n}"

  case "${opt}" in
    --pass=?*)
      DDNS_PASS="${!opt_n#*=}"
      ;;
    --pass)
      (( opt_n++ ))
      DDNS_PASS="${!opt_n}"
      ;;
    --hosts=?*)
      DDNS_HOSTS="${!opt_n#*=}"
      ;;
    --hosts)
      (( opt_n++ ))
      DDNS_HOSTS="${!opt_n}"
      ;;
    --ip=?*)
      DDNS_IP="${!opt_n#*=}"
      ;;
    --ip)
      (( opt_n++ ))
      DDNS_IP="${!opt_n}"
      ;;
    *)
      ;;
  esac

  (( opt_n++ ))
done
