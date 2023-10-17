function parmabox_refresh {

if ! docker ps >/dev/null ; then announce "Docker is not running." ; return 1 ; fi
please_wait
docker stop parmabox
docker rm parmabox
parmabox_build
parmabox_run
parmabox_exec

success "ParmaBox" "being refreshed"

}