function get_uddns {
[[ ! -e $dp/.uddns_enabled ]] && announce_blue "No static IP? No problem. With UDDNS, you can simiulate a static IP address for
                                          \r    your machine. Fee is cheap AF, 1.5k sats per month, paid yearly (18k sats)." && return 1 

git clone git@github-uddns:armantheparman/uddns.git $pp/uddns 2>$dn || { enter_continue "Something went wrong. Contact Parman." ; return 1 ; }
installed_conf_add "uddns-end"
for file in $pp/uddns/src/*.sh ; do source $file ; done
menu_uddns
return 0
}