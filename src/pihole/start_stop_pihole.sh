function start_pihole {
    cd $hp/pihole
    debug3 "in start pihole"
    docker compose start
    debug3 "after docker compose start"
}
function stop_pihole {
    cd $hp/pihole
    docker compose stop 
}
