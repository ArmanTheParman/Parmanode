# added a debug function with slightly more complexity than
# a read command, to stop any arguments being passed to read
# without my knowledge. Only the character "d" will allow th
# code to contine.



function debug {
if [[ $debug == 1 ]] ; then
echo "Debug point. Message:
"
echo "$1
"
log "debug" "${1}"
enter_continue
return 0
fi
}

function debug2 {
if [[ $debug == 2 ]] ; then
echo "${1}"
log "debug2" "${1}"
enter_continue
return 0
fi
}

function debug3 {
if [[ $debug == 3 ]] ; then
echo "${1}"
log "debug3" "${1}"
enter_continue
return 0
fi
}

function debug4 {
if [[ $debug == 4 ]] ; then
echo "${1}"
log "debug4" "${1}"
enter_continue
return 0
fi
}


function debug_user {
if [[ $user == debug ]] ; then
echo "${1}"
log "debug_user" "${1}"
enter_continue
return 0
fi
}

function debug_fast {
if [[ $fast == debug ]] ; then
echo "${1}"
enter_continue
return 0
fi

}
function ut {
if [[ $ut == 1 ]] ; then 
echo "{$1}"
echo "debug point. Pausing here."
enter_continue
fi
}