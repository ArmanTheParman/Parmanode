function install_torssh {

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
    Installation of a Tor SSH server.
$orange
    This wizard will help you set up an SSH Tor server on this machine, and give info
    about how to route traffic through Tor on the other machine that will be
    connecting to this one.

    The benefit is that you can SSH between the two computers even if they are not on
    the same home private network. ie you can access your computer when away from 
    home, as long as you make a note of the onion address (keep it private), and
    know he username and password to log in.

    Do you want to proceed? $green

                          y)    yes, do it
$red
                          n)    nah, this is useless to me
$orange
########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;
y) break ;;
n) return 1 ;;
*) invalid ;;
esac
done


if ! which nc >$dn 2>&1 ; then

    if [[ $OS == Linux ]] ; then sudo apt update -y && sudo apt-get install netcat-traditional ; fi

    if [[ $OS == Mac ]] ; then
        if ! which brew ; then install_homebrew ; fi
        brew install netcat
        if ! which nc >$dn 2>&1 ; then 
            announce "Couldn't install netcat. Aborting." 
            return 1
        fi
    fi
fi

# in case SSH remote log in is off
if [[ $OS == "Mac" ]] ; then
    sudo systemsetup -setremotelogin on >$dn 2>&1
fi

if ! which tor >$dn 2>&1 ; then install_tor ; fi

# edit torrc...
if ! sudo cat $torrc | grep "# Additions by Parmanode..." >$dn 2>&1 ; then
echo "# Additions by Parmanode..." | sudo tee -a $torrc >$dn 2>&1
fi

echo "HiddenServiceDir $varlibtor/ssh-service/" | sudo tee -a $torrc >$dn 2>&1
echo "HiddenServicePort 22 127.0.0.1:22" | sudo tee -a $torrc >$dn 2>&1
installed_conf_add "torssh-start"
restart_tor

if [[ ! -d $HOME/.ssh ]] ; then make_parmanode_ssh_keys ; fi
if [[ ! -f $HOME/.ssh/config ]] ; then sudo touch $HOME/.ssh/config ; fi


if ! grep -q "Host *.onion" $HOME/.ssh/config ; then
cat << EOF | tee -a $HOME/.ssh/config >$dn 2>&1
    Host *.onion
    ProxyCommand nc -x localhost:9050 -X 5 %h %p
EOF
fi
set_terminal
echo -e "
########################################################################################

    Please wait...
$cyan
    A Tor service wil be created.
$orange
    If you are waiting longer than$red 2 minutes$orange, something has gone wrong.

    In that case please hit$cyan control-c$orange to abort and report the but to Parman. You might
    also want to just try uninstalling the partial installation and try again. There's
    a chance that could work just fine.

########################################################################################
"

while [[ -z $ONION_ADDR_SSH ]] ; do
get_onion_address_variable ssh
sleep 2
done

set_terminal_high ; echo -e "
########################################################################################

    Parmanode has set up a$cyan Tor SSH service$orange on this machine. This is the$pink 'HOST'$orange. The
    other computer that connect to it is the$pink 'CLIENT'$orange. 
    
    The client needs to route its SSH traffic through it's own Tor proxy. To do that 
    you need to add the following lines to the file $HOME/.ssh/config 
    (if the file does not exits, then create the file in that location).
$green
    Host *.onion
        ProxyCommand nc -x localhost:9050 -X 5 %h %p
$orange
    Parmanode has already done this for you on this HOST computer (not client, 
    obviously, that's another computer), so it is ready to be a CLIENT to another 
    HOST you may wish to set up. That's confusing, sorry. Read it again slowly.

    On the CLIENT, after modifying the config file, restart the SSH service. For 
    a Linux machine, do this:
$green
    sudo systemctl restart ssh $orange
     
    For a Mac, just restart the silly thing, and also consider upgrading your
    life to Linux.

    Then you can ssh into this machine from the client, as follows:
$bright_blue
    ssh $USER@$ONION_ADDR_SSH $orange
    
    You can get this address again later from the SSH Tor menu.

    Please be aware that ssh over Tor is slow and annoying, but it's sometimes nice
    to have available if there is nothing else to access your computer from outside
    your home network.

########################################################################################
"
enter_continue
installed_conf_add "torssh-end"
success "SSH Tor service" "being installed"
}

