function choose_electrum_version {
while true ; do
clear ; echo -e "
########################################################################################
    
               Please indicate your preferred version of Electrum.
$cyan
                                    1)$orange       4.4.4
$cyan
                                    2)$orange       4.6.2

                                    3)$orange       custom

########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

1)
export electrum_version="4.4.4" 
break
;;
2)
export electrum_version="4.6.2"
break
;;
3)
announce "If you choose this, you are responsible to verify the software yourself.$red x$orange to abort"
case $enter_cont in x) continue ;; esac
announce "Please enter the version you want."
jump $enter_cont
export electrum_version=$enter_cont
export skip_verify="true"
;;
*)
invalid
;;
esac
done

return 0 
}
