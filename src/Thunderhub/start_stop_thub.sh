function start_thunderhub {
docker ps >/dev/null 2>&1 || { announce "Please start Docker" ; return 1 ; } 
docker start thunderhub
}

function stop_thunderhub {
docker stop thunderhub
}