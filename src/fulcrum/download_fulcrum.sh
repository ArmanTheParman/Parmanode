function download_fulcrum {

cd $HOME/parmanode/fulcrum || { debug "Failed to change into fulcrum directory. Aborting" ; return 1 ; }

if [[OS == "Linux" ]] ; then

        if [[ $chip == "x86_64" ]] ; then
            curl -LO https://github.com/cculianu/Fulcrum/releases/download/v1.9.1/Fulcrum-1.9.1-x86_64-linux.tar.gz && \
            curl -LO https://github.com/cculianu/Fulcrum/releases/download/v1.9.1/Fulcrum-1.9.1-x86_64-linux.tar.gz.asc && \
            log "fulcrum" "files downloaded" && return 0 \
            || { debug "Failed to download Fulcrum" ; return 1 ; }
            fi

	    if [[ $chip == "aarch64" ]] ; then 				#64 bit Pi4 
            curl -LO https://github.com/cculianu/Fulcrum/releases/download/v1.9.1/Fulcrum-1.9.1-arm64-linux.tar.gz && \
            curl -LO https://github.com/cculianu/Fulcrum/releases/download/v1.9.1/Fulcrum-1.9.1-arm64-linux.tar.gz.asc && \
            log "fulcrum" "files downloaded" && return 0 \
            || { debug "Failed to download Fulcrum" ; return 1 ; }
            fi
fi

log "fulcrum" "download function called, but no if statement entered, so nothing downloaded." && return 1 || return 1
}