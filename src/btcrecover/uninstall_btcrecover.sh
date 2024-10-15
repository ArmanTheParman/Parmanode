function uninstall_btcrecover {
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall BTC Recover? 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "x" 
read choice
set_terminal

if [[ $choice == "y" || $choice == "Y" ]] ; then true
    else 
    return 1
    fi

if ! docker ps > /dev/null 2>&1 ; then
announce "Docker needs to be running. Aborting."
return 1
fi

docker stop btcrecover >$dn 2>&1
docker rm btcrecover

if [[ -d $hp/btcrecover_data ]] ; then
set_terminal ; echo -e "
########################################################################################

    Remove $hp/btcrecover_data directory?

                            yes)      Do it

                            n)        Don't

########################################################################################
"
choose xpmq ; read choice ; set_terminal
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