# added a debug function with slightly more complexity than
# a read command, to stop any arguments being passed to read
# without my knowledge. Only the character "d" will allow th
# code to contine.



function debug {
echo "$1" | tee -a $dp/debug.log >/dev/null 2>&1
if [[ $debug == 1 ]] ; then
echo -e "Debug point. Message:
"
echo -e "$1
"
unset enter_cont ; enter_continue ; export enter_cont
if [[ $enter_cont == q || $enter_cont == "exit" ]] ; then exit 0 ; fi
return 0
fi
}

function debug2 {
echo "$1" | tee -a $dp/.debug2.log >/dev/null 2>&1
if [[ $debug == 2 ]] ; then
echo -e "${1}"
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