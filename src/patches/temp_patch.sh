function temp_patch {

cleanup_parmanode_service
add_rpcbind
truncatedebuglog
#Docker containers sometimes won't have $USER variable set...
if [[ -e /.dockerenv && -z $USER ]] ; then
    USER=$(whoami) >/dev/null 2>&1
    echo "USER=$USER ##added by Parmanode" | sudo tee -a $HOME/.bashrc >/dev/null 
fi

tmux_patch

#put in next patch
set_github_config
#fix 8332 value in torrc - linux ; remove Jan 2025
if which tor >$dn 2>&1 ; then #exit if tor not even installed
     
    #make it work for linux or mac
    if [[ $OS == Linux ]] ; then torrc=/etc/tor/torrc ; unset prefix ; fi
    if [[ $OS == Mac ]] ; then torrc=/usr/local/etc/tor/torrc ; prefix=/usr/local ; fi

    #if 8332 service exists then exposed to previous error, need to fix. Clean entries first.
    if grep -q "8332" "$torrc" 2>$dn ; then

        sudo gsed -i "/var\/lib\/tor\/bitcoin-service/d"        $torrc 
        sudo gsed -i "/HiddenServicePort 8332 127.0.0.1:8332/d" $torrc 
        sudo gsed -i "/HiddenServicePort 8332 127.0.0.1:8333/d" $torrc 
        sudo gsed -i "/HiddenServicePort 8333 127.0.0.1:8332/d" $torrc 
        sudo gsed -i "/HiddenServicePort 8333 127.0.0.1:8333/d" $torrc 
        
        #add corrected entries in order
        echo "HiddenServiceDir $prefix/var/lib/tor/bitcoin-service/" | sudo tee -a $torrc >$dn 2>&1
        echo "HiddenServicePort 8333 127.0.0.1:8333" | sudo tee -a $torrc >$dn 2>&1
    fi
fi
#fix homebrew path order ; remove June 2025
if [[ $OS == Mac ]] && which brew >$dn && [[ -e $bashrc ]] ; then
sudo gsed -i "/\$PATH:\/opt\/homebrew\/bin/d" $bashrc
    if ! grep -q "PATH=/opt/homebrew/bin" < $bashrc ; then
    echo "PATH=/opt/homebrew/bin:\$PATH" | sudo tee -a $bashrc >$dn 2>&1
    fi
fi
#remove June 2025
make_lnd_service_tor
#remove June 2025 - make sure all electrs docker has socat installed
if grep -q "electrsdkr" < $ic ; then
    if ! docker exec -it electrs bash -c "which socat" >/dev/null 2>&1 ; then
        docker exec -d electrs bash -c "sudo apt-get install socat -y" >$dn 2>&1
    fi
fi

if [[ -e $HOME/.electrs ]] && [[ ! -e $HOME/.electrs/cert.pem ]] ; then
make_ssl_certificates "electrs"
fi

#remove in 2025
#because of version2 of electrs install, small bug introduced in the
#install detection. This fixes it.
if grep -q "electrs-start" < $ic && grep -q "electrs2-end" < $ic ; then
sudo gsed -i "/electrs-start/d" $ic 
parmanode_conf_add "electrs2-start"
fi
#remove in 2025
if [[ ${message_jq} != 1 ]] && grep -q "electrs" < $ic && ! which jq > /dev/null ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode has detected that you have electrs installed, and due to some
    recent electrs menu improvements, you need to install$cyan jq$orange to make it display nice.
    
    Do that now?
$green
                           y)        Go for it
$red
                           n)        No
$bright_blue
                           nooo)     No and never ask again
$orange 
########################################################################################
"
choose "xq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) previous ;; n|N) break ;;
y|yes)
if [[ $OS == Mac ]] && ! which brew >/dev/null ; then
announce "To install jq, Parmanode needs to install HomeBrew first. You can abandon
    this in the next screen, and next time install jq your self if you want."
brew_check
fi
install_jq
break
;;
nooo)
hide_messages_add "jq" "1"
break
;;
*)
invalid ;;
esac
done
fi

if ! grep -q "parmashell" < $bashrc ; then
uninstall_parmashell silent ; install_parmashell
fi

#Make /media/$USER with permission of $USER. - Refactor this in to the code at some point. Maybe to the installation.
sudo chown $USER:$(id -gn) /media/$USER >/dev/null 2>&1
sudo setfacl -m g::r-x /media/parman >$dn 2>&1 #make sure group has access

#Fulcrum - added 10 Nov
if [[ -f "$hp/fulcrum/fulcrum.conf" && ! -L "$hp/fulcrum/fulcrum.conf" ]] ; then
    stop_fulcrum
    sudo mkdir -p $HOME/.fulcrum >$dn 2>&1
    sudo mv $hp/fulcrum/fulcrum.conf $HOME/.fulcrum/ && \
        sudo ln -s $HOME/.fulcrum/fulcrum.conf $hp/fulcrum/fulcrum.conf >$dn 2>&1 && \
        log "fulcrum" "moved fulcrum.conf to new location and made symlink"
    start_fulcrum
fi
sudo gsed -i 's/500001/50001/' $torrc >$dn 2>&1

debug temppatchend

# potentially large file that's not needed, caused by a bug
sudo rm $(ls $HOME/.*uninstall_parmanodebackup*)
}