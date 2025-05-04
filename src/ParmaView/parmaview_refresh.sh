function parmaview_refresh {

if ! docker ps >$dn ; then announce "Docker is not running." ; return 1 ; fi
please_wait
docker stop parmaview
docker rm parmaview
parmaview_build
parmaview_run
parmaview_parmanode

success "ParmaView" "being refreshed"
}