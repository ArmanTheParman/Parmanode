function install_electrumx {
export install=electrumx

if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi
sned_sats
if [[ $computer_type == Pi ]] ; then
set_terminal ; echo -e "
########################################################################################
    Parmanode has detected you're using a Pi. I have not added support for Pis' yet.
    Aborting.
########################################################################################
"
enter_continue ; jump $enter_cont ; return 1
fi

preamble electrumx

source $pc $ic >$dn 2>&1
grep -q "bitcoin-end" $ic || { announce "Must install Bitcoin first. Aborting." && return 1 ; }

# check Bitcoin settings
unset rpcuser rpcpassword prune server
if [[ -e $bc ]] ; then
source $bc >$dn
else
clear
echo -e "The$cyan bitcoin.conf$orange file could not be detected. Can heppen if Bitcoin is
supposed to sync to the external drive and it is not connected and mounted.
Hit$cyan <enter>$orange to try again once you connect the drive."
fi
if [[ ! -e $bc && $debug != 1 ]] ; then
announce "Couldn't detect bitcoin.conf - Aborting."
return 1 
fi
check_pruning_off || return 1
check_server_1 || return 1
export dontstartbitcoin="true"
check_rpc_bitcoin
unset dontstartbitcoin
isbitcoinrunning
if [[ $bitcoinrunning == "true" ]] ; then
while true ; do
set_terminal
echo -e "
########################################################################################

    It's advisable if Bitcoin is stopped when Electrum X is being installed to 
    conserve system resources for the compiling procedure. Shall Parmanode stop it 
    for you? 
$green
               y)$orange       Stops Bitcoin for now
$red
               n)$orange       Leave Bitcoin running

########################################################################################  
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; n|N) break ;; m|M) back2main ;; 
y|Y) stop_bitcoin ; break ;;
*) invalid ;;
esac
done
fi #and if bitcoin running

electrumx_dependencies || { debug "dependencies failed" ; return 1 ; }
debug "dependencies passed"
#download source code form github
download_electrumx || { debug "download failed" ; return 1 ; }
debug "download passed"
#install
cd $hp/electrumx || { enter_continue "error, electrumx directory doesn't exist" && return 1 ; }
{ pip3 install . || pip3 install . --break-system-packages ; } || { debug "'pip install .failed." ; return 1 ; }
debug "pip install passed"

#prepare drives. #drive_electrumx= variable set.
choose_and_prepare_drive "Electrumx" || return 1

make_ssl_certificates "electrumx" \
|| announce "SSL certificate generation failed. Proceed with caution." ; debug "ssl certs done"

#get drive variables
source $HOME/.parmanode/parmanode.conf >$dn

if [[ $drive_electrumx == external ]] && grep "=external" $pc | grep -vq "electrumx" ; then #don't grep 'external' alone, too ambiguous
    # format not needed 
    # Get user to connect drive.
      pls_connect_drive || return 1 

    # check if there is a backup electrumx_db on the drive and restore it
      restore_electrumx_drive #prepares drive based on existing backup and user choices
      if [[ $OS == Linux ]] ; then sudo chown -R $USER:$(id -gn) $original > $dn 2>&1 ; fi
                                                           # $original from function restore_electrumx_drive
elif [[ $drive_electrumx == external ]] ; then

      format_ext_drive "electrumx" || return 1
      #make directory electrumx_db not needed because config file makes that hapen when electrumx run
      mkdir -p $parmanode_drive/electrumx_db >$dn
      sudo chown -R $USER $parmanode_drive/electrumx_db >$dn
fi

prepare_drive_electrumx || { debug "prepare_drive_electrumx failed" ; return 1 ; } 

#if dir exists, test inside function
if [[ $drive_electrumx == internal ]] ; then
restore_internal_electrumx_db || { debug " restore_internal_electrumx_db failed" ; return 1 ; }
fi

#Electrum X docs say this is needed
if ! grep -q "rest=1" $bc ; then
echo "rest=1" | sudo tee -a $bc >$dn 2>&1
fi

make_electrumx_conf || { debug "make electrumx conf failed." ; return 1 ; }
make_electrumx_service || { debug "make electrumx service failed." ; return 1 ; }
electrumx_banner
installed_config_add "electrumx-end"  
success "Electrum X has been installed. Please restart Bitcoin once for 
    Electrum X to work properly."
}