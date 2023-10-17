function parmabox_refresh {

if ! docker ps >/dev/null ; then announce "Docker is not running." ; return 1 ; fi

docker stop parmabox
docker rm parmabox
parmabox_build
parmabox_exec
parmabox_run

success "ParmaBox" "being refreshed"

}