# added a debug function with slightly more complexity than
# a read command, to stop any arguments being passed to read
# without my knowledge. Only the character "d" will allow th
# code to contine.



function debug {
if [[ $2 != silent ]] ; then
log "debug" "${1}"
fi

if [[ $debug == 1 ]] ; then
echo -e "Debug point. Message:
"
echo -e "$1
"
unset enter_cont ; enter_continue ; export enter_cont
if [[ $enter_cont == q ]] ; then exit 0 ; fi
return 0
fi
}

function debug2 {
if [[ $debug == 2 ]] ; then
echo -e "${1}"
log "debug2" "${1}"
unset enter_cont ; enter_continue ; export enter_cont
if [[ $enter_cont == q ]] ; then exit 0 ; fi
return 0
fi
}

function debug3 {
if [[ $debug == 3 ]] ; then
echo -e "${1}"
log "debug3" "${1}"
unset enter_cont ; enter_continue ; export enter_cont
if [[ $enter_cont == q ]] ; then exit 0 ; fi
return 0
fi
}

function debug4 {
if [[ $debug == 4 ]] ; then
echo -e "${1}"
log "debug4" "${1}"
unset enter_cont ; enter_continue ; export enter_cont
if [[ $enter_cont == q ]] ; then exit 0 ; fi
return 0
fi
}