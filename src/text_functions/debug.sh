# added a debug function with slightly more complexity than
# a read command, to stop any arguments being passed to read
# without my knowledge. Only the character "d" will allow th
# code to contine.

#truncatedebuglog to keep file size manageable.

function debug {
echo $(date) | tee -a $dp/debug.log >/dev/null 2>&1
echo "${FUNCNAME[0]} <-- ${FUNCNAME[1]}" | tee -a $dp/debug.log >/dev/null 2>&1
echo "$1" | tee -a $dp/debug.log >/dev/null 2>&1
echo "##############################" | tee -a $dp/debug.log >/dev/null 2>&1
if [[ $debug == 1 ]] ; then
echo -e "${FUNCNAME[0]} <-- ${FUNCNAME[1]}" 
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
echo $(date) | tee -a $dp/debug2.log >/dev/null 2>&1
echo "${FUNCNAME[0]} <-- ${FUNCNAME[1]}" | tee -a $dp/debug2.log >/dev/null 2>&1
echo "$1" | tee -a $dp/.debug2.log >/dev/null 2>&1
if [[ $debug == 2 ]] ; then
echo -e "Debug point:

$1
"
unset enter_cont ; enter_continue ; export enter_cont
if [[ $enter_cont == q || $enter_cont == "exit" ]] ; then exit 0 ; fi
fi
}

function debug3 {
echo "$1" | tee -a $dp/.debug3.log >/dev/null 2>&1
if [[ $debug == 3 ]] ; then
echo -e "${1}"
unset enter_cont ; enter_continue ; export enter_cont

return 0
fi
}