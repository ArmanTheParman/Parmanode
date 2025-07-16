function menu_iptables {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

while true ; do
if [[ $toggle == "on" ]] ; then     

export show="     FILTER:     INPUT / OUTPUT / FORWARD

     NAT:        PREROUTING / POSTROUTING / OUTPUT / INPUT

     MANGLE:     PREROUTING / INPUT / FORWARD / OUTPUT / POSTROUTING

     RAW:        PREROUTING / OUTPUT

     SECURITY:   INPUT / OUTPUT / FORWARD"

set_terminal 45 128
else
unset show
set_terminal 38 128
fi

echo -e "
################################################################################################################################$cyan
                                               IP Tables Menu$orange
################################################################################################################################
$green
THERE ARE 5 TABLES, each with chains: ('t' to toggle)
$show

$cyan
    lfa,lfi,lfo,lff)$orange         List FILTER Table Rules $green(ALL,INPUT,OUTPUT,FORWARD)$orange
$cyan
    lna,lnp,lnt,lno,lni)$orange     List NAT Table Rules $green(ALL,PREROUTING,POSTROUTING,OUTPUT,INPUT)$orange
$cyan
    lma,lmi,lmo,lmf)$orange         List MANGLE Table Rules $green(ALL,INPUT,FORWARD,OUPUT,POSTROUTING)$orange
$cyan
    lra,lrp,lro)$orange             List RAW Table Rules $green(ALL,PREROUTING,OUTPUT)$orange
$cyan
    lsa,lsi,lso,lsf)$orange         List SECURITY Table Rules $green(ALL,INPUT,OUTPUT,FORWARD)$orange
$cyan
    z*)$orange                      Zero data count from selected list combination above. Type$green z$orange and$green selection $orange
                                    ${red}Eg: zmi will zero the mangle input chain$orange
$cyan
    za)$orange                      Zero data count for all tables and all chains
$cyan
    s*)$orange                      See a list of the$green syntax$orange used to add rules. Type$green s$orange and$green selection $orange
                                    ${red}Eg: srp will show syntax rules in the the raw prerouting chain$orange
$orange
################################################################################################################################
"
choose xpmq ; read choice ; clear
jump $choice ; jump_mpq || return 1
case $choice in
t)
export toggle=on
;;
syntax)
sudo iptables -S
enter_continue 
;;
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

