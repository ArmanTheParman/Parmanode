function uninstall_parmanostr {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                               Uninstall ParmaNostr
$orange
    Are you sure? 

                    y)    Yes, uninstall

                    n)    Nah, abort
$red
                    rem)  Yes, and remove the nostr_keys directory too
$orange


########################################################################################
"
choose xpmq 
read choice
set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n)
return 1
;;
y)
break
;;
rem)
rem="true"
break
;;
esac
done

set_terminal


if [[ $rem == "true" ]] ; then
    rm -rf $dp/.nostr_keys >/dev/null 2>&1
fi

installed_conf_remove "parmanostr"
success "ParmaNostr has been removed"
}
