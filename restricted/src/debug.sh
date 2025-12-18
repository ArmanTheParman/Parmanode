export dn="/dev/null"

function debug {
filef=$dp/debugf.log
file=$pvlog
dn="/dev/null"

debugprint="$(date)\t${FUNCNAME[1]}--${BASH_LINENO[0]} <-- ${FUNCNAME[2]}--${BASH_LINENO[1]}\n$*\n##############################\n" 

echo -e "$debugprint" | tee -a $file >$dn 2>&1
echo -e "\tDEBUG HIT: $(date)\t${FUNCNAME[1]}::${BASH_LINENO[0]}" | tee -a $filef >$dn 2>&1

if [[ $debug == 1 ]] ; then
    echo -e "$debugprint"
    return 0
fi
}

function debugf {
file=$dp/debugf.log
echo -e "$(date): ${FUNCNAME[1]}\t<-------------------${FUNCNAME[2]}" >> $file 2>&1
}