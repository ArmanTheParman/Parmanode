function install_tor_ssh {

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
    Installation of an Tor SSH server.
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
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;
y) break ;;
n) return 1 ;;
*) invalid ;;
esac
done


if ! which nc >/dev/null 2>&1 ; then

    if [[ $OS == Linux ]] ; then sudo apt update -y && sudo apt-get install netcat-traditional ; fi

    if [[ $OS == Mac ]] ; then
        if ! which brew ; then install_homebrew ; fi
        brew install netcat
    fi
fi

if ! which tor >/dev/null 2>&1 ; then install_tor ; fi


# edit torrc...
if ! sudo cat /etc/tor/torrc | grep "# Additions by Parmanode..." >/dev/null 2>&1 ; then
echo "# Additions by Parmanode..." | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
fi

echo "HiddenServiceDir /var/lib/tor/ssh-service/" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
echo "HiddenServicePort 22 127.0.0.1:22" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
installed_conf_add "torssh-start"
sudo systemctl restart tor ssh

if [[ ! -d $HOME/.ssh ]] ; then sudo mkdir $HOME/.ssh ; fi
if [[ ! -f $HOME/.ssh/config ]] ; then touch $HOME/.ssh/config ; fi


if ! grep -q "Host *.onion" < $HOME/.ssh/config ; then
cat << EOF | sudo tee -a $HOME/.ssh/config >/dev/null 2>&1
Host *.onion
	ProxyCommand nc -x localhost:9050 -X 5 %h %p
EOF
fi
clear
echo -e "
########################################################################################

    Please wait...
$cyan
    A Tor service is being created.
$orange
    If you are waiting longer than$red 2 minutes$orange, something has gone wrong.

    In that case please hit$cyan control-c$orange to abort and report the but to Parman. You might
    also want to just try uninstalling the partial installation and try again. There's
    a chance that could work just fine.

########################################################################################
"
enter_continue



while [[ -z $ONION_ADDR_SSH ]] ; do
get_onion_address_variable ssh
sleep 1 
echo $ONION_ADDR_SSH
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
    I believe indentation matters, but I haven't checked. Just copy these 2 lines
    exactly as written. BTW, Parmanode has already done this for you on this HOST
    computer (not client, obviously, that's another computer), so it is ready to be 
    a CLIENT to another HOST you may wish to set up. That's confusing, sorry. Read it
    again slowly.

    On the CLIENT, after modifying the config file, restart the SSH service. For 
    a Linux machine, do this:
$green
    sudo systemctl restart ssh $orange
     
    For a Mac, just restart the stupid thing, and also consider upgrading your
    life to Linux.

    Then you can ssh into this machine from the client, as follows:
$bright_blue
    ssh username_of_host@$ONION_ADDR_SSH $orange
    
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

