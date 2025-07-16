function menu_iptables {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

while true ; do
set_terminal
echo -e "
########################################################################################$cyan
                                IP Tables Menu$orange
########################################################################################


$cyan
                  list)$orange           List Filter Table Rules



########################################################################################
"
choose xpmq ; read choice ; clear
jump $choice ; jump_mpq || return 1
case $choice in
list)
sudo iptables -t filter -L -v -n --line-numbers
enter_continue
;;
esac
}

