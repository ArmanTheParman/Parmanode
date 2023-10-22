function fulcrum_to_remote {    #called by menu_fulcrum function

set_terminal ; echo -e "
########################################################################################

    You're about to switch which Bitcoin Core instance Fulcrum connects to. Parmanode
    will help you with that. But be aware that if you do this, you'll need to 
    delete the data that Fulcrum has already sync'ed (if any). 

    My testing has shown this to be necessary, but if you can connect and get no
    errors without starting fresh, that's great.

    To delete the fulcrum database, you can do it manually, or use the Parmanode
    Fulcrum menu option available. After that, start Fulcrum, and it should sync to
    the computer you've selected here.

########################################################################################
"
enter_continue

#ensure passwords match
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                  Match passwords
$orange
    It's necessary that the username and password stored in$yellow bitcoin.conf$orange on the$green other $orange
    computer matches the username and password stored in$yellow fulcrum.conf$orange on$green this$orange computer.

    This instance of Parmanode has no access to the other computer, so it's up to you
    to set it up there and make a note of it to use here. Parmanode will help you 
    put the username and password in fulcrum.conf on this computer.

                  <enter>    Set username and password in fulcrum.conf

########################################################################################
"
choose "xpq" ; read choice
case $choice in q|Q|QUIT|Quit) exit 0 ;; p|P) return 1 ;; "") break ;; *) invalid ;; esac
done

password_changer || return 1

edit_user_pass_fulcrum_docker $rpcuser $rpcpassword remote || return 1 

ssl_port_change_fulcrum || return 1 

bitcoindIP_change_fulcrum || return 1 

set_terminal ; echo "
########################################################################################

                                Bitcoin rpcallowip

    The Bitcoin Core node on the other computer must accept connections from the IP
    address of the Fulcrum server. You can find your computer's IP address using the
    Parmanode menu (startup --> tools --> what's my IP). 

    Then, you need to add the following line to the bitcoin.conf file on that 
    computer: 

                            rpcallowip=IP_address

    Obviously, replace \"IP_address\" with the actual IP address of the Fulcrum
    computer.

    And remember to restart Bitcoin for configuration files changes to take effect.

########################################################################################
"
enter_continue
return 0
}

