function install_electrumx {

if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi

if [[ $computer_type == Pi ]] ; then
set_terminal ; echo -e "
########################################################################################
    Parmanode has detected you're using a Pi. I have not added support for Pis' yet.
    Aborting.
########################################################################################
"
enter_continue ; return 1
fi

source $pc $ic >/dev/null 2>&1
grep -q "bitcoin-end" < $ic || { announce "Must install Bitcoin first. Aborting." && return 1 ; }
if ! which nginx >/dev/null ; then install_nginx 
fi

# check Bitcoin settings
unset rpcuser rpcpassword prune server
if [[ -e $bc ]] ; then
source $bc >/dev/null
else
clear
echo "The bitcoin.conf file could not be detected. Can heppen if Bitcoin is
supposed to sync to the external drive and it is not connected and mounted.
Hit <enter> to try again once you connect the drive."
fi
if [[ ! -e $bc ]] ; then
announce "Couldn't detect bitcoin.conf - Aborting."
return 1 
fi
check_pruning_off || return 1
check_server_1 || return 1
export dontstartbitcoin=true
check_rpc_bitcoin
unset dontstartbitcoin
isbitcoinrunning
if [[ $bitcoinrunning == true ]] ; then
while true ; do
set_terminal
echo -e "
########################################################################################

    It's advisable if Bitcoin is stopped when Electrum X is being installed to 
    conserve system resources for the compiling procedure. Shall Parmanode stop it 
    for you? 
$green
               y)       Stops Bitcoin Core for now
$orange
               n)       Leave Bitcoin Core running

########################################################################################  
"
choose "xpmq"
read choice ; set_terminal
case $choice in
q|Q) exit ;;
p|P) return 1 ;;
n|N) break ;;
m|M) back2main ;; 
y|Y) stop_bitcoind ; break ;;
*) invalid ;;
esac
done
fi #and if bitcoin running

electrumx_dependencies || { debug "dependencies failed" ; return 1 ; }

#download source code form github
download_electrumx || { debug "download failed" ; return 1 ; }

#install
cd $hp/electrumx && pip3 install .[rocksdb,ujson] || { debug "'pip3 install .' failed." ; return 1 ; }

choose_and_prepare_drive electrumx || { debug "choose and prepare drive failed." ; return 1 ; }

make_ssl_certificates "electrumx" \
|| announce "SSL certificate generation failed. Proceed with caution." ; debug "ssl certs done"

nginx_electrumx add || { debug "nginx_electrumx failed" ; return 1 ; }

#prepare drives. #drive_electrumx= variable set.
{ choose_and_prepare_drive "Electrumx" ; log "electrumx" ; } || { debug "choose_and_prepare_drive failed" ; return 1 ; } 
 
#get drive variables for others: fulcrum, bitcoin, and electrs
source $HOME/.parmanode/parmanode.conf >/dev/null

if [[ ($drive_electrumx == "external" && $drive == "external") || \
      ($drive_electrumx == "external" && $drive_fulcrum == "external") || \
      ($drive_electrumx == "external" && $drive_electrs == "external") ]] ; then 
    # format not needed
    # Get user to connect drive.
      pls_connect_drive || return 1 

    # check if there is a backup electrumx_db on the drive and restore it
      restore_electrumx_drive #prepares drive based on existing backup and user choices
      if [[ $OS == Linux ]] ; then sudo chown -R $USER:$(id -gn) $original > /dev/null 2>&1 ; fi
                                                           # $original from function restore_electrumx_drive
elif [[ $drive_electrumx == external ]] ; then

      format_ext_drive "electrumx" || return 1
      #make directory electrumx_db not needed because config file makes that hapen when electrumx run
      mkdir -p $parmanode_drive/electrumx_db >/dev/null
      sudo chown -R $USER $parmanode_drive/electrumx_db >/dev/null
fi

prepare_drive_electrumx || { debug "prepare_drive_electrumx failed" ; return 1 ; } 

#if dir exists, test inside function
if [[ $drive_electrumx == internal ]] ; then
restore_internal_electrumx_db || { debug " restore_internal_electrumx_db failed" ; return 1 ; }
fi

make_electrumx_conf || { debug "make electrumx conf failed." ; return 1 ; }
make_electrumx_service || { debug "make electrumx service failed." ; return 1 ; }
installed_config_add "electrumx-end"  
Success "Electrum X" "being installed."
}