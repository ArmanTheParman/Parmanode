function log_counter {
file="$HOME/.parmanode/log_counter.conf"
if [[ -f $file ]] ; then source $file >/dev/null
fi

if [[ -z $log_count ]] ; then
    echo "log_count=0" > $file 2>/dev/null
else
    log_count=$((log_count + 1))
    echo log_count=$log_count > $file 2>/dev/null
fi

source $file >/dev/null ; export log_count=$log_count >/dev/null #exporting to use in parent function
}