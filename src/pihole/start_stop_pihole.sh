function start_pihole {
    cd $hp/pihole
    docker compose start
}
function stop_pihole {
    cd $hp/pihole
    docker compose stop 
}
