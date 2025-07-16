function menu_iptables {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

while true ; do
set_terminal 38 110
echo -e "
##############################################################################################################$cyan
                                IP Tables Menu$orange
##############################################################################################################

$cyan
    la,li,lo,fw)$orange     List Filter Table Rules $green(ALL,INPUT,OUTPUT,FORWARD)$orange
$cyan
    za)$orange              Zero data count for$green all$orange tables (Filter,NAT,Mangle,Raw,Security)
$cyan
    zfi,zfo,zff)$orange     Zero data in filter table$green (INPUT,OUTPUT,FORWARD) $orange
$orange
##############################################################################################################
"
choose xpmq ; read choice ; clear
jump $choice ; jump_mpq || return 1
case $choice in
fw)
sudo iptables -t filter -L FORWARD -v --line-numbers 
enter_continue
;;
lo)
sudo iptables -t filter -L OUTPUT -v --line-numbers 
enter_continue
;;
li)
sudo iptables -t filter -L INPUT -v --line-numbers 
enter_continue
;;
la)
sudo iptables -t filter -L -v --line-numbers 
#Alternatives
#  -L lists all unless value like INPUT added after
#  sudo iptables-save
#  -n disables name resolution
enter_continue
;;
z)
sudo iptables -Z
enter_continue
;;
esac
done
}

