function build_fulcrum_docker {

cd $original_dir    #created in run_parmanode. Need to get back to build dockerfile from here.

set_terminal ; echo "
########################################################################################

    To instull Fulcrum, Docker will now build a Linux/Fulcrum container, as 
    specified within the Parmanode software. Please sit back and enjoy. It will take 
    a minute or so.

########################################################################################
"
enter_continue

{ docker build -t fulcrum ./ 2>&1 | tee $HOME/.parmanode/docker_build.log ; } \
|| log "fulcrum" "fulcrum docker build failed" && return 1 

echo "
########################################################################################

    The build process should be completed.  A log file for the process has been saved 
    to:
                    $HOME/.parmanode/.docker_build.log

    Fulcrum can now be started from the Fulcrum menu.

########################################################################################                    
"
enter_continue
return 0
}