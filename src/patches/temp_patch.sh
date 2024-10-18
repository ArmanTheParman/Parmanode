function temp_patch {

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

        delete_line $torrc "HiddenServiceDir $prefix/var/lib/tor/bitcoin-service/"
        delete_line $torrc "HiddenServicePort 8332 127.0.0.1:8332"
        delete_line $torrc "HiddenServicePort 8332 127.0.0.1:8333"
        delete_line $torrc "HiddenServicePort 8333 127.0.0.1:8332"
        delete_line $torrc "HiddenServicePort 8333 127.0.0.1:8333"
        
        #add corrected entries in order
        echo "HiddenServiceDir $prefix/var/lib/tor/bitcoin-service/" | sudo tee -a $torrc >$dn 2>&1
        echo "HiddenServicePort 8333 127.0.0.1:8333" | sudo tee -a $torrc >$dn 2>&1
    fi
fi

#fix homebrew path order ; remove June 2025
if [[ $OS == Mac ]] && which brew >$dn && [[ -e $HOME/.zshrc ]] ; then
delete_line "$HOME/.zshrc" "\$PATH:/opt/homebrew/bin"
    if ! grep -q "PATH=/opt/homebrew/bin" < $HOME/.zshrc ; then
    echo "PATH=/opt/homebrew/bin:\$PATH" | sudo tee -a $HOME/.zshrc >$dn 2>&1
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
delete_line "$ic" "electrs-start"
parmanode_conf_add "electrs2-start"
fi

#remove in 2025
#stream directive now in "stream.conf"
if [[ $OS == "Linux" && -f /etc/nginx/nginx.conf ]] ; then
if grep -q "include electrs.conf;" < /etc/nginx/nginx.conf ; then
delete_line "/etc/nginx/nginx.conf" "include electrs.conf"
sudo rm /etc/nginx/electrs.conf >/dev/null 2>&1
fi
fi

if [[ -e $bc ]] ; then
    
    #Remove in 2025
    if grep -q "electrumx-end" < $ic && ! grep -q "rest=1" < $bc ; then
    echo "rest=1" | sudo tee -a $bc >/dev/null 2>&1
    fi
    
    #Remove in 2025
    #recommended by electrumX docs
    if ! grep -q "rpcservertimeout=" < $bc ; then
    echo "rpcservertimeout=120" | sudo tee -a $bc >/dev/null 2>&1
    fi

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

#remove in June 2025
cleanup_bashrc_zshrc
#echo "source $HOME/parman_programs/parmanode/src/ParmaShell/parmashell_functions" | sudo tee -a $bashrc >/dev/null 2>&1
debug temppatchend

#Make /media/$USER with permission of $USER. - Refactor this in to the code at some point.
sudo chown $USER:$(id -gn) /media/$USER >/dev/null 2>&1
}

