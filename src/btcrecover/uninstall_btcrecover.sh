function uninstall_btcrecover {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall BTC Recover? 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) backtomain ;; y) break ;; n) return 1 ;; *) invalid ;;
esac
done

if ! podman ps >$dn 2>&1 ; then
announce "Docker needs to be running. Aborting."
return 1
fi

podman stop btcrecover >$dn 2>&1
podman rm btcrecover

if [[ -d $hp/btcrecover_data ]] ; then
set_terminal ; echo -e "
########################################################################################

    Remove$cyan $hp/btcrecover_data$orange directory?

                            yes)      Do it

                            n)        Don't

########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
yes)
sudo rm -rf $hp/btcrecover_data 
;;
esac
fi

#need sudo, some dirs have container permissions
installed_config_remove "btcrecover"
success "BTC recover has been uninstalled"
return 0
}