function fulcrum_to_remote {    #called by menu_fulcrum function

#ensure passwords match
while true ; do
set_terminal ; echo "
########################################################################################

                                  Match passwords

    It's necessary that the username and password stored in bitcoin.conf on the other 
    computer matches the username and password stored in fulcrum.conf on this computer.

    This instance of Parmanode has no access to the other computer, so it's up to you
    to set it up there and make a note of it to use here. Parmanode will help you 
    put the username and password in fulcrum.conf on this computer.

                  <enter>    Set username and password in fulcrum.conf

########################################################################################
"
choose "xpq" ; read choice
case $choice in q|Q|QUIT|Quit) exit 0 ;; p|P) return 1 ;; "") break ;; *) invalid ;; esac
done

password_changer ; if [ $? == 1 ] ; then return 1 ; fi

edit_user_pass_fulcrum_docker $rpcuser $rpcpassword ; if [ $? == 1 ] ; then return 1 ; fi

ssl_port_change_fulcrum ; if [ $? == 1 ] ; then return 1 ; fi

bitcoindIP_change_fulcrum ; if [ $? == 1 ] ; then return 1 ; fi

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

