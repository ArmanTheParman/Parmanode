# added a debug function with slightly more complexity than
# a read command, to stop any arguments being passed to read
# without my knowledge. Only the character "d" will allow th
# code to contine.

#truncatedebuglog to keep file size manageable.

export dn="/dev/null"

function debug {
file=$dp/debug.log
filef=$dp/debugf.log
[[ $parmaview == 1 ]] && file=$pvlog
dn="/dev/null"

debugprint="$(date)\t${FUNCNAME[1]}--${BASH_LINENO[0]} <-- ${FUNCNAME[2]}--${BASH_LINENO[1]}\n$*\n##############################\n" 

echo -e "$debugprint" | tee -a $file >$dn 2>&1
echo -e "\tDEBUG HIT: $(date)\t${FUNCNAME[1]}::${BASH_LINENO[0]}" | tee -a $filef >$dn 2>&1

if [[ $debug == 1 ]] ; then
    echo -e "$debugprint"
    unset enter_cont ; enter_continue ; export enter_cont

    if [[ $enter_cont == "q" || $enter_cont == "exit" ]] ; then exit 0 ; fi
    if [[ $enter_cont == "d" ]] ; then unset debug ; fi
    if [[ $enter_cont == "env" ]] ; then check_variables ; fi
    return 0
fi
}

function debugf {
file=$dp/debugf.log

echo -e "$(date): ${FUNCNAME[1]}\t<-------------------${FUNCNAME[2]}" >> $file 2>&1

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

function debugfile {
# turns on debug if file exists, but only debugfile function will work, not debug()
if test -f $tmp/debugon ; then

echo -e "${FUNCNAME[1]} <-- ${FUNCNAME[2]}" 
echo -e "DEBUGFILE enabled: Message:

$@
"
env
unset enter_cont ; enter_continue ; export enter_cont
if [[ $enter_cont == "q" || $enter_cont == "exit" ]] ; then exit 0 ; fi
if [[ $enter_cont == "d" ]] ; then unset debug ; fi
if [[ $enter_cont == "env" ]] ; then check_variables ; fi
return 0
fi
}
