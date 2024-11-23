function log_counter {
file="$HOME/.parmanode/log_counter.conf"
if [[ -f $file ]] ; then source $file >$dn
fi

if [[ -z $log_count ]] ; then
    echo "log_count=0" > $file 2>$dn
else
    log_count=$((log_count + 1))
    echo log_count=$log_count > $file 2>$dn
fi

source $file >$dn 
export log_count=$log_count #exporting to use in parent function
}