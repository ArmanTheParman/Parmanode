function extract_fulcrum_tar {

mkdir $HOME/parmanode/fulcrum/download 
tar -xvf -C $HOME/parmanode/fulcrum/download/ && log "fulcrum" "fulcrum tar extracted" 

return 0
}