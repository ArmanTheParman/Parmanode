function suggest_brew {

if [[ $OS != Mac ]] ; then return 0 ; fi

if grep -q "no_homebrew_check=true" < $hm 2>$dn ; then return 0 ; fi

if ! which brew >$dn 2>&1 ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode has detected that you don't have$cyan HomeBrew$orange installed on your Mac.

    It's better to have it as Parmanode will be able to add a few bits and bobs
    that make your experience better, and it will look prettier as well. The main 
    downside is that it can some time to compile. It's not strictly necessary, just
    better. 
    
    You have options...
$cyan
                      1) $orange  Okie dokie, do it now
$cyan
                      2) $orange  Nah
$cyan
                      3) $orange  Nah, and don't ask again
$cyan
                      4) $orange  Tell me how to do it later


########################################################################################
"
choose xq ; read choice ; set_terminal ;
case $choice in
q|Q) exit ;; 
1) 
please_wait
update_computer
break
;;
2|""|s|p|P)
break
;;
3)
echo "no_homebrew_check=true" >> $hm 2>$dn
break
;;
4)
announce "To install or update HomeBrew, the best way is to go to the Parmanode --> Tools
    menu, and choose update computer."
;;
*)
invalid
;;
esac
done
fi
}
    