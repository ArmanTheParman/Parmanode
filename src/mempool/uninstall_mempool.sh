function uninstall_mempool {

install_check "mempool" "uninstall" || { already_uninstalled ; return 1 ; }

if [[ $OS == "Mac" ]] ; then
    if ! docker ps >/dev/null 2>&1 ; then
        set_terminal
        echo "Docker needs to run to cleanly remove the mempool container."
        enter_continue
        start_docker_mac
    fi
fi

cd $HOME/parmanode/mempool/docker && docker compose down 
cd $HOME
rm -rf $HOME/parmanode/mempool >/dev/null 2>&1

log "mempool" "Mempool uninstalled"
installed_config_remove "mempool"

success "Mempool" "being uninstalled."
}