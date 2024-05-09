function install_electrs {
export install_electrs_docker_variable=false
source $pc $ic >/dev/null 2>&1

grep -q "electrsdkr" < $ic && announce "Oops, you're trying to install a second instance of electrs.
    It seems you alread have a Docker version of electrs installed on the 
    system. Parmanode cannot install electrs if the Docker version is 
    already installed. Bad things can happen. Aborting." && return 1 

grep -q "bitcoin-end" < $ic || { announce "Must install Bitcoin first. Aborting." && return 1 ; }

sned_sats

#if ! which nginx >/dev/null ; then install_nginx ; fi
#trying socat instead
if [[ $OS == Linux ]] ; then
if ! which socat >/dev/null ; then sudo apt-get update -y ; sudo apt install socat -y ; fi
elif [[ $OS == Mac ]] ; then brew_check || return 1 ; brew install socat 
fi

#going with service file instead for now
#make_socat_script electrs
make_socat_service_listen
make_socat_service_publish

# check Bitcoin settings
unset rpcuser rpcpassword prune server
if [[ -e $bc ]] ; then
source $bc >/dev/null
else
clear
echo "The bitcoin.conf file could not be detected. Can happen if Bitcoin is
supposed to sync to the external drive and it is not connected and mounted.
Hit <enter> to try again once you connect the drive."
fi
if [[ ! -e $bc ]] ; then
announce "Couldn't detect bitcoin.conf - Aborting."
return 1 
fi

if ! which jq >/dev/null ; then install_jq ; fi

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

    It's advisable if Bitcoin is stopped when electrs is being installed to conserve
    system resources for the compiling procedure. Shall Parmanode stop it for you? 

               y)       Stop Bitcoin Core for now

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



if [[ $OS == Mac ]] ; then 
minV=11 && if [[ $MacOSVersion_major -lt $minV ]] ; then
announce "electrs has been tested successfully on newer versions of MacOS.
    It fails with older versions. 

    To use Bitoin Core with a wallet using this computer, either update
    to a later version of MacOS (11+) or use Sparrow directly with
    Bitcoin Core (it doesn't need electrs or Fulcrum).

    Aborting.
    "
    return 1
fi
brew_check electrs || return 1 
fi

unset electrs_compile 
restore_electrs #get electrs_compile true/false. If no backup found, electrs_compile=true is set
if [[ $electrs_compile == "false" ]] ; then 

    please_wait
    echo -e "$pink copying/moving files...$orange"
    sleep 2
    rm -rf $HOME/parmanode/electrs/ 
    cp -Rv $HOME/.electrs_backup $HOME/parmanode/electrs

    installed_config_add "electrs2-start"

else #if [[ $electrs_compile == "true" ]] ; then

    preamble_install_electrs || return 1

    set_terminal ; please_wait
    build_dependencies_electrs || return 1 
    download_electrs && log "electrs" "download_electrs success" 
    { compile_electrs && backup_electrs_do ; } || return 1
    log "electrs" "compile_electrs done" 

fi
#remove old certs (in case they were copied from backup), then make new certs
rm $HOME/parmanode/electrs/*.pem > /dev/null 2>&1
make_ssl_certificates "electrs" || announce "SSL certificate generation failed. Proceed with caution."  ; debug "check ssl certs done"

#trying socat instead
#nginx_stream electrs install || { debug "nginx stream failed" ; return 1 ; } #must be after certificates made or install will fail

#prepare drives. #drive_electrs= variable set.
choose_and_prepare_drive "Electrs" && log "electrs" "choose and prepare drive function borrowed"
 
#get drive variables for fulcrum, electrumx, and bitcoin
source $HOME/.parmanode/parmanode.conf >/dev/null

if [[ ($drive_electrs == "external" && $drive == "external") || \
      ($drive_electrs == "external" && $drive_fulcrum == "external") || \
      ($drive_electrs == "external" && $drive_electrumx == "external") ]] ; then 
    # format not needed
    # Get user to connect drive.
      pls_connect_drive || return 1 

    # check if there is a backup electrs_db on the drive and restore it
      restore_electrs_drive #prepares drive based on existing backup and user choices
      if [[ $OS == Linux ]] ; then sudo chown -R $USER:$(id -gn) $original > /dev/null 2>&1 ; fi
                                                           # $original from function restore_electrs_drive
elif [[ $drive_electrs == external ]] ; then

      format_ext_drive "electrs" || return 
      #make directory electrs_db not needed because config file makes that hapen when electrs run
      mkdir -p $parmanode_drive/electrs_db
fi

prepare_drive_electrs || { log "electrs" "prepare_drive_electrs failed" ; return 1 ; } 
        debug "prepare drive done"

#if it exists, test inside function
if [[ $drive_electrs == internal ]] ; then
restore_internal_electrs_db || return 1
fi

#config
make_electrs_config ; debug "config done"

if [[ $OS == Linux ]] ; then make_electrs_service ; debug "service file done" ; fi

installed_config_add "electrs2-end" ; debug "finished electrs install"

# just automatically backing up right after compile, no need to ask.
# if [[ $electrs_compile == "true" ]] ; then
#     backup_electrs
# fi

success "electrs" "being installed"

}

########################################################################################

function check_pruning_off {
if [[ $prune -gt 0 ]] ; then
set_terminal ; echo -e "
########################################################################################
    Note that Electrum Server won't work if Bitcoin is pruned. You'll have to 
    completely start bitcoin sync again without pruning to use Electrs. Sorry. If you 
    think this is wrong and want to proceed, type 'yolo' then <enter>. Otherwise, just 
    hit $green<enter>$orange
########################################################################################
"
read choice
if [[ $choice == yolo ]] ; then return 0 ; fi
return 1
else
return 0
fi
}

function check_server_1 {
if [[ $server -ne 1 ]] ; then 
debug "Hit s to skip server=1 check." && if [[ $enter_cont == s ]] ; then return 0 ; fi
announce "\"server=1\" needs to be included in the bitcoin.conf file." \
"Please do that, restart Bitcoin, and try again. Note, this will
resync the index which will take a long time. Aborting." 
return 1 
fi
}


