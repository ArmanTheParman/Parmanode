function extract_fulcrum {
tar -xvf $HOME/parmanode/fulcrum/Ful*gz -C $HOME/parmanode/fulcrum/ || \
 { debug "Failed to extract Fulcrum tar file" && log "fulcrum" "failed to extract fulcrum tar file" && return 1 ; }
}