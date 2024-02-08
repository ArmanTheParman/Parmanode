# added a debug function with slightly more complexity than
# a read command, to stop any arguments being passed to read
# without my knowledge. Only the character "d" will allow th
# code to contine.



function debug {
if [[ $debug == 1 ]] ; then
echo -e "Debug point. Message:
"
echo -e "$1
"
log "debug" "${1}"
enter_continue
if [[ $enter_cont == q ]] ; then unset enter_cont ; exit 0 ;; fi
return 0
fi
}

function debug2 {
if [[ $debug == 2 ]] ; then
echo -e "${1}"
log "debug2" "${1}"
enter_continue
if [[ $enter_cont == q ]] ; then unset enter_cont ; exit 0 ;; fi
return 0
fi
}

function debug3 {
if [[ $debug == 3 ]] ; then
echo -e "${1}"
log "debug3" "${1}"
enter_continue
if [[ $enter_cont == q ]] ; then unset enter_cont ; exit 0 ;; fi
return 0
fi
}

function debug4 {
if [[ $debug == 4 ]] ; then
echo -e "${1}"
log "debug4" "${1}"
enter_continue
if [[ $enter_cont == q ]] ; then unset enter_cont ; exit 0 ;; fi
return 0
fi
}