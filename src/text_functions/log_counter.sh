function log_counter {
file="$HOME/.parmanode/log_counter.conf"
source $file >/dev/null

if [[ -z $log_count ]] ; then
    echo "log_count=0" > $file
else
    log_count=$((log_count + 1))
    echo log_count=$log_count > $file
fi

source $file >/dev/null ; export log_count=$log_count >/dev/null #exporting to use in parent function
}