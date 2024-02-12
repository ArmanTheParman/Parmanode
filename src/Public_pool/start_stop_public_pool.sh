function stop_public_pool {
docker stop public_pool public_pool_ui
}

function start_public_pool {
if ! docker ps >/dev/null 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue
return 1
fi

docker start public_pool public_pool_ui
}