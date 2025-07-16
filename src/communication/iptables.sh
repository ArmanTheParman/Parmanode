function menu_iptables {

if [[ $debug != 1 ]] ; then 
    if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi
fi

while true ; do
if [[ $toggle == "on" ]] ; then     

export show="\n$blue     FILTER:     INPUT / OUTPUT / FORWARD

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
    ${red}Add ',v' to the selection for verbose 
    Add ',n' to disable name resolution 
    eg lnt,v,n$orange

$cyan
  lfa/lfi/lfo/lff)$orange         List FILTER Table Rules $green(ALL/INPUT/OUTPUT/FORWARD)$orange
$cyan
  lna/lnp/lnt/lno/lni)$orange     List NAT Table Rules $green(ALL/PREROUTING/POSTROUTING/OUTPUT/INPUT)$orange
$cyan
  lma/lmp/lmi/lmf/lmo/lmt)$orange List MANGLE Table Rules $green(ALL/PREROUTING/INPUT/FORWARD/OUPUT/POSTROUTING)$orange
$cyan
  lra/lrp/lro)$orange             List RAW Table Rules $green(ALL/PREROUTING/OUTPUT)$orange
$cyan
  lsa/lsi/lso/lsf)$orange         List SECURITY Table Rules $green(ALL/INPUT/OUTPUT/FORWARD)$orange
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
unset table chain v n
case $choice in
l*)
#choose table
   if [[ $choice =~ ^lf.* ]] ; then table="filter" ; fi
   if [[ $choice =~ ^ln.* ]] ; then table="nat" ; fi
   if [[ $choice =~ ^lm.* ]] ; then table="mangle" ; fi
   if [[ $choice =~ ^lr.* ]] ; then table="raw" ; fi
   if [[ $choice =~ ^ls.* ]] ; then table="security" ; fi
#choose chain
   if [[ $choice =~ ^l.a.* ]] ; then chain="" ; fi
   if [[ $choice =~ ^l.i.* ]] ; then chain="INPUT" ; fi
   if [[ $choice =~ ^l.o.* ]] ; then chain="OUTPUT" ; fi
   if [[ $choice =~ ^l.f.* ]] ; then chain="FORWARD" ; fi
   if [[ $choice =~ ^l.p.* ]] ; then chain="PREROUTING" ; fi
   if [[ $choice =~ ^l.t.* ]] ; then chain="POSTROUTING" ; fi
#invalid...
   if [[ $choice =~ ^lf(t|p) ]] ; then invalid ; continue ; fi
   if [[ $choice =~ ^lnf ]] ; then invalid ; continue ; fi
   if [[ $choice =~ ^lmp ]] ; then invalid ; continue ; fi
   if [[ $choice =~ ^lr(t|i|f) ]] ; then invalid ; continue ; fi
   if [[ $choice =~ ^ls(t|p) ]] ; then invalid ; continue ; fi
#verbose and name resolution disabling
   if [[ $choice =~ .*,v.* ]] ; then v="-v" ; fi
   if [[ $choice =~ .*,n.* ]] ; then n="-n" ; fi

   sudo iptables -t $table -L $chain $v $n | less
;;

lo)
sudo iptables -t filter -L OUTPUT -v
enter_continue
;;
li)
sudo iptables -t filter -L INPUT -v 
enter_continue
;;
#Alternatives
#  sudo iptables-save
#  -n disables name resolution

t)
[[ -z $toggle ]] && export toggle=on && continue
unset toggle
;;
syntax)
sudo iptables -S
enter_continue 
;;
fw)
sudo iptables -t filter -L FORWARD -v --line-numbers 
enter_continue
;;

z)
sudo iptables -Z
enter_continue
;;
esac
done
}

