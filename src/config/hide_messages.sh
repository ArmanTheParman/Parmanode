
function hide_messages_add {
label="$1"
value="$2"

hide_messages_remove $label

echo "message_$label=$value" | tee -a $HOME/.parmanode/hide_messages.conf
return 0
}

function hide_messages_remove {
label=$1
delete_line "$HOME/.parmanode/hide_messages.conf" "message_$label="
return 0
}

