function docker_running {
if ! docker ps >/dev/null 2>&1 ; then set_terminal 
announce "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
return 1
else
return 0
}