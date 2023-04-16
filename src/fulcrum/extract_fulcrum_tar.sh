function extract_fulcrum_tar {

cd $HOME/parmanode/fulcrum || { debug "Failed to change into fulcrum directory. Aborting" ; return 1 ; }

mkdir download && \
tar -xvf -C ./download/ || \
debug "Failed to extract Fulcrum tar file" && return 1

log "fulcrum" "fulcrum tar extracted" 



return 0

}