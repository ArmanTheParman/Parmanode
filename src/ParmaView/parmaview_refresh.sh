function parmaview_refresh {

if ! docker ps >$dn ; then announce "Docker is not running." ; return 1 ; fi
please_wait
docker stop parmaview
docker rm parmaview
parmaview_build
parmaview_run
parmanode_in_parmaview

success "ParmaView" "being refreshed"
}