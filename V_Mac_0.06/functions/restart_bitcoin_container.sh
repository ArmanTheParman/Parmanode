function restart_bitcoin_container {
    clear
    echo "Restarting parmanode_bitcoin_container."
    sudo docker restart parmanode_bitcoin_container
    sudo docker logs
    echo "Hit <enter> to continue." ; read
    return 0
}