function extract_fulcrum_tar {

tar -xvf $HOME/parmanode/fulcrum/Ful*gz -C $HOME/parmanode/fulcrum/ || \
{ debug "Failed to extract Fulcrum tar file" && log "fulcrum" "failed to extract fulcrum tar file" && return 1 ; }

log "fulcrum" "fulcrum tar extracted" 

return 0

}