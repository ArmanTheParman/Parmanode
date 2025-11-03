
function hide_messages_add {
label="$1"
value="$2"

hide_messages_remove $label
debug "hma"
echo "message_$label=$value" | tee -a $HOME/.parmanode/hide_messages.conf >$dn 2>&1
return 0
}

function hide_messages_remove {
label=$1
gsed -i "/message_$label=/d" $hm >$dn 2>&1
debug "hmr done"
return 0
}

