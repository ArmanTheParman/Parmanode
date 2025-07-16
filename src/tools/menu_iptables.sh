function menu_iptables {

if [[ $debug != 1 ]] ; then 
    if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi
fi

sudo which iptables >$dn 2>&1 || {
    if yesorno "IPTables is not installed. Do it?" ; then 
        sudo apt-get update -y ; sudo apt-get install iptables -y 
    else
        return 1
    fi
}

while true ; do
if [[ $toggle == "on" ]] ; then     

export show="\n$blue     FILTER:     INPUT / OUTPUT / FORWARD

     NAT:        PREROUTING / POSTROUTING / OUTPUT / INPUT

     MANGLE:     PREROUTING / INPUT / FORWARD / OUTPUT / POSTROUTING

     RAW:        PREROUTING / OUTPUT

     SECURITY:   INPUT / OUTPUT / FORWARD"

set_terminal 48 128
else
unset show
set_terminal 40 128
fi

echo -e "
################################################################################################################################$cyan
                                                     IPTables Menu$orange
################################################################################################################################

$green
     THERE ARE 5 TABLES, each with chains: ('t' to toggle)
$show

     ${red}Add ',v' to the selection for verbose 
     Add ',n' to disable name resolution 
     eg lnt,v,n$orange

$cyan
    lfa/lfi/lfo/lff)$orange         List FILTER Table Rules $green    (ALL/INPUT/OUTPUT/FORWARD)$orange
$cyan
    lna/lnp/lnt/lno/lni)$orange     List NAT Table Rules $green       (ALL/PREROUTING/POSTROUTING/OUTPUT/INPUT)$orange
$cyan
    lma/lmp/lmi/lmf/lmo/lmt)$orange List MANGLE Table Rules $green    (ALL/PREROUTING/INPUT/FORWARD/OUPUT/POSTROUTING)$orange
$cyan
    lra/lrp/lro)$orange             List RAW Table Rules $green       (ALL/PREROUTING/OUTPUT)$orange
$cyan
    lsa/lsi/lso/lsf)$orange         List SECURITY Table Rules $green  (ALL/INPUT/OUTPUT/FORWARD)$orange
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
l*|s*|z*)
#choose table
   if [[ $choice =~ ^.f.* ]] ; then table="filter" ; fi
   if [[ $choice =~ ^.n.* ]] ; then table="nat" ; fi
   if [[ $choice =~ ^.m.* ]] ; then table="mangle" ; fi
   if [[ $choice =~ ^.r.* ]] ; then table="raw" ; fi
   if [[ $choice =~ ^.s.* ]] ; then table="security" ; fi
#choose chain
   if [[ $choice =~ ^..a.* ]] ; then chain="" ; fi
   if [[ $choice =~ ^..i.* ]] ; then chain="INPUT" ; fi
   if [[ $choice =~ ^..o.* ]] ; then chain="OUTPUT" ; fi
   if [[ $choice =~ ^..f.* ]] ; then chain="FORWARD" ; fi
   if [[ $choice =~ ^..p.* ]] ; then chain="PREROUTING" ; fi
   if [[ $choice =~ ^..t.* ]] ; then chain="POSTROUTING" ; fi
#invalid...
   if [[ $choice =~ ^.f(t|p) ]] ; then invalid ; continue ; fi
   if [[ $choice =~ ^.nf ]] ; then invalid ; continue ; fi
   if [[ $choice =~ ^.r(t|i|f) ]] ; then invalid ; continue ; fi
   if [[ $choice =~ ^.s(t|p) ]] ; then invalid ; continue ; fi
#verbose and name resolution disabling
   if [[ $choice =~ .*,v.* ]] ; then v="-v" ; fi
   if [[ $choice =~ .*,n.* ]] ; then n="-n" ; fi

case $choice in 
   za)
   sudo iptables -Z ; enter_continue ;;
   l*)
   sudo iptables -t $table -L $chain $v $n | less ;;
   s*)
   sudo iptables -t $table -S $chain | less ;;
   z*)
   sudo iptables -t $table -Z $chain ; enter_continue ;;
   esac
;;

t)
[[ -z $toggle ]] && export toggle=on && continue
unset toggle
;;
*)
invalid
;;
esac
done
}

#Alternatives
#  sudo iptables-save