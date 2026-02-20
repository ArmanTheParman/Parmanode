#Not complete! Do not manually run.

function install_eps {

if [[ $OS == "Mac" ]] ; then nomac ; return 1 ;fi

if  grep -q eps-end $ic ; then announce "EPS already installed" ; jump $enter_cont ; return 0 ; fi
if  grep -q eps-start $ic ; then announce "EPS partially installed" ; jump $enter_cont ; uninstall_eps; return 0 ; fi

export skipformatting="true"

source $pc $ic >$dn 2>&1

if [[ $debug != 1 ]] ; then
grep -q "bitcoin-end" $ic || { announce "Must install Bitcoin first. Aborting." && return 1 ; }
sned_sats
fi

if [[ $OS == "Linux" ]] ; then
make_socat_service_eps
fi

#
eps_dependencies || { log "eps" "dependencies failed" ; return 1 ; } ; debug "dependencies done"


# check Bitcoin settings
unset rpcuser rpcpassword prune server
if [[ -e $bc ]] ; then
source $bc >$dn
else
clear
echo -e "The$cyan bitcoin.conf$orange file could not be detected. Can happen if Bitcoin is
supposed to sync to the external drive and it is not connected and mounted.
Hit$cyan <enter>$orange to try again once you connect the drive."
fi

if [[ ! -e $bc && $debug != 1 ]] ; then
announce "Couldn't detect bitcoin.conf - Aborting."
return 1 
fi

check_server_1 || return 1

export dontstartbitcoin="true" ; check_rpc_bitcoin ; unset dontstartbitcoin

download_eps || { log "eps" "download_eps failed" ; return 1 ; } ; debug "download done"

#remove old certs (in case they were copied from backup), then make new certs
rm $HOME/parmanode/eps/*.pem > $dn 2>&1
make_ssl_certificates "eps" || announce "SSL certificate generation failed. Proceed with caution."  ; debug "check ssl certs done"

#prepare drives. #drive_electrs= variable set.
choose_and_prepare_drive "eps" || return 1

#get drive variables for fulcrum, electrumx, and bitcoin
source $pc >$dn

if [[ $drive_eps == "external" ]] ; then

      if [[ -d $pd/eps_db ]] ; then 
      true
      else
          if ! mount | grep -q $dp ; then
              format_ext_drive "eps" || return 1
          fi
      mkdir -p $pd/eps_db
      sudo chown -R $USER $parmanode_drive/eps_db >$dn 2>&1
      fi
fi

prepare_drive_eps || { log "eps" "prepare_drive_eps failed" ; return 1 ; } 
        debug "prepare drive done"

#if it exists, test inside function
if [[ $drive_eps == "internal" ]] ; then
restore_internal_eps_db || return 1
fi

#config
########################################################################################################################
########################################################################################################################
    #make_eps_config ; debug "config done"
########################################################################################################################
########################################################################################################################

########################################################################################################################
########################################################################################################################
#if [[ $OS == "Linux" ]] ; then make_eps_service ; debug "service file done" ; fi
########################################################################################################################
########################################################################################################################

installed_config_add "eps-end" 

eps_tor
success "Electrum Personal Server has been installed"

isbitcoinrunning

if [[ $bitcoinrunning == "false" ]] ; then
yesorno "Want Parmanode to start Bitcoin for you?" && start_bitcoin 
fi

}
