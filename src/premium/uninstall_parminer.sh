function uninstall_parminer {

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                               Uninstall ParMiner?
$orange
    Are you sure? 

                            y)    Yes, uninstall

                            n)    Nah, abort


########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n) return 1 ;;
y) break ;;
esac
done

sudo rm -rf $hp/bfgminer
installed_conf_remove "parminer"
sudo rm -rf $pp/parminer
uninstall_bfgminer silent
success "ParMiner has been uninstalled"
}

function uninstall_bfgminer {

if [[ $1 != "silent" ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                               Uninstall BFGMiner
$orange
    Are you sure? 

                            y)    Yes, uninstall

                            n)    Nah, abort


########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n) return 1 ;;
y) break ;;
esac
done
fi

sudo rm -rf $hp/bfgminer
installed_conf_remove "bfgminer"
if [[ $1 != "silent" ]] ; then
success "BFGMiner has been uninstalled"
fi
}
