function start_thunderhub {
docker ps || { announce "Please start Docker" ; return 1 ; } 
docker start thunderhub
}

function stop_thunderhub {
docker stop thunderhub
}