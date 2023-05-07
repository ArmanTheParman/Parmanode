function uninstall_mempool {

install_check "mempool" "uninstall" || { already_uninstalled ; return 1 ; }

cd $HOME/parmanode/mempool/docker && docker compose down && \
rm -rf $HOME/parmanode/mempool >/dev/null 2>&1

log "mempool" "Mempool uninstalled"
installed_config_remove "mempool"

success "Mempool" "being uninstalled."
}