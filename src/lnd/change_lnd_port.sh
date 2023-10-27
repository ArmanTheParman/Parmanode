function change_lnd_port {
set_lnd_port || return 1
get_extIP
swap_string "$HOME/.lnd/lnd.conf" "externalip=" "externalip=$extIP:$lnd_port"
swap_string "$HOME/.lnd/lnd.conf" "listen=0.0.0.0:973" "listen=0.0.0.0:$lnd_port"
restart_lnd
return 0
}