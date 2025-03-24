function start_pihole {
    cd $hp/pihole
    podman compose start
}
function stop_pihole {
    cd $hp/pihole
    podman compose stop 
}
