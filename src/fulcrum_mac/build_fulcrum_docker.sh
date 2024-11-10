function build_fulcrum_docker {
docker build -t fulcrum $pn/src/fulcrum_mac/ || fail="true"
enter_continue
if [[ $fail == "true" ]] ; then return 1 ; else return 0 ; fi
}