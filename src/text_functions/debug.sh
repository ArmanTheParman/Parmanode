# added a debug function with slightly more complexity than
# a read command, to stop any arguments being passed to read
# without my knowledge. Only the character "d" will allow th
# code to contine.

function chuck {
    if [[ $chuck ==1 ]] ; then
    echo "Debugging for chuck."
    echo "$1"
    enter_continue
    return 0
    fi
}


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
	
function debug1 {
if [[ $debug == 1 ]] ; then
debug "$1"
fi
}

function debug2 {

if [[ $debug == 2 ]] ; then
echo "${1}"
enter_continue
return 0
fi

}

function ut {
if [[ $ut != 1 ]] ; then return 0 ; fi
echo "{$1}"
echo "debug point. Pausing here."
enter_continue
}