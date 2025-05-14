# slightly convoluted but allows exiting functionality to expand for later versions.
# clean_exit should be placed at code initial execution.

function clean_exit {
trap parmanode_clean_exit EXIT
}

function parmanode_clean_exit {
    rm $dp/.tempsudo/* >/dev/null 2>&1
    tput sgr0 #resets colours of users terminal before quitting
    reset
    exit
}
