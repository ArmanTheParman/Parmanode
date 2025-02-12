# added a debug function with slightly more complexity than
# a read command, to stop any arguments being passed to read
# without my knowledge. Only the character "d" will allow th
# code to contine.

#truncatedebuglog to keep file size manageable.

dn="/dev/null"

function debug {
dn="/dev/null"
echo $(date) | tee -a $dp/debug.log >$dn 2>&1
echo "${FUNCNAME[1]} <-- ${FUNCNAME[2]}" | tee -a $dp/debug.log >$dn 2>&1
echo "$1" | tee -a $dp/debug.log >$dn 2>&1
echo "##############################" | tee -a $dp/debug.log >$dn 2>&1
if [[ $debug == 1 ]] ; then
echo -e "${FUNCNAME[1]} <-- ${FUNCNAME[2]}" 
echo -e "Debug point. Message:

$1
"
unset enter_cont ; enter_continue ; export enter_cont
if [[ $enter_cont == q || $enter_cont == "exit" ]] ; then exit 0 ; fi
if [[ $enter_cont == d ]] ; then unset debug ; fi
if [[ $enter_cont == env ]] ; then check_variables ; fi
return 0
fi
}

function debug2 {
dn="/dev/null"
echo $(date) | tee -a $dp/debug2.log >$dn 2>&1
echo "${FUNCNAME[0]} <-- ${FUNCNAME[1]}" | tee -a $dp/debug2.log >$dn 2>&1
echo "$1" | tee -a $dp/debug2.log >$dn 2>&1
if [[ $debug == 2 ]] ; then
echo -e "Debug point:

$1
"
unset enter_cont ; enter_continue ; export enter_cont
if [[ $enter_cont == q || $enter_cont == "exit" ]] ; then exit 0 ; fi
fi
}

function debug3 {
dn="/dev/null"
echo "$1" | tee -a $dp/.debug3.log >$dn 2>&1
if [[ $debug == 3 ]] ; then
echo -e "${1}"
unset enter_cont ; enter_continue ; export enter_cont

return 0
fi
}