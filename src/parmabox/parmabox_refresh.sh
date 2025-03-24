function parmabox_refresh {

if ! podman ps >$dn ; then announce "Docker is not running." ; return 1 ; fi
please_wait
podman stop parmabox
podman rm parmabox
parmabox_build
parmabox_run
parmabox_exec

success "ParmaBox" "being refreshed"

}