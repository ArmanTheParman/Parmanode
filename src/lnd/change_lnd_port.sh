function change_lnd_port {
set_lnd_port || return 1
get_extIP
swap_sting "$HOME/.lnd/lnd.conf" "externalip=" "externalip=$extIP:$lnd_port"
restart_lnd
return 0
}