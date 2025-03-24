function build_fulcrum_podman {
podman build -t fulcrum $pn/src/fulcrum/ || fail="true"
enter_continue
if [[ $fail == "true" ]] ; then return 1 ; else return 0 ; fi
}