function build_fulcrum_docker {

cd $original_dir    #created in run_parmanode. Need to get back to build dockerfile from here.

set_terminal ; echo "
########################################################################################

    To install Fulcrum, Docker will now build a Linux/Fulcrum container, as 
    specified within the Parmanode software. Please sit back and enjoy. It will take 
    a minute or so.

########################################################################################
"
sleep 0.5

{ docker build -t fulcrum ./src/fulcrum_mac/ 2>&1 | tee $HOME/.parmanode/docker_build.log ; } \
|| { log "fulcrum" "fulcrum docker build failed" && return 1 ; }

}