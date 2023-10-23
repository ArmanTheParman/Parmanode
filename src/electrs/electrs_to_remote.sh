function electrs_to_remote {    

set_terminal ; echo -e "
########################################################################################

    You're about to switch which Bitcoin Core instance electrs connects to. Parmanode
    will help you with that. But be aware that if you do this, you$pink MAY$orange need to 
    delete the data that electrs has already sync'ed (if any). 
    
    My testing showed that the sync should transition smoothly. However on FULCRUM, 
    which is a different type of electrum server, when performing this maneuver, 
    the database gets corrupted. It's like being suspicious of a drug being toxic to
    humans becuase it was toxic to rabbits. The worst case scenario is you lose a
    couple of days resyncing the electrs data - you'll be fine ;)
$green
    In summary, there's a chance the database gets corrupted, but probably not. 
$orange
    To delete the electrs database, you can do it manually, or use the Parmanode
    electrs menu option available . After that, start electrs, and it should 
    sync to the computer you've selected here.

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
    computer matches the username and password stored in$yellow electrs config.toml file$orange 
    on$green this$orange computer.

    This instance of Parmanode has no access to the other computer, so it's up to you
    to set it up there and make a note of it to use here. Parmanode will help you 
    put the username and password in the config.toml file on this computer.

                  <enter>    Set username and password in config.toml

########################################################################################
"
choose "xpq" ; read choice
case $choice in q|Q|QUIT|Quit) exit 0 ;; p|P) return 1 ;; "") break ;; *) invalid ;; esac
done

password_changer || return 1
electrs_edit_user_pass $rpcuser $rpcpassword remote || return 1
debug "after electrs_edit_user_pass"
#ssl_port_change_fulcrum || return 1 
#bitcoindIP_change_fulcrum || return 1 
electrs_bitcoinIP_change || return 1

set_terminal ; echo -e "
########################################################################################
$cyan
                                Bitcoin rpcallowip
$orange
    The Bitcoin Core node on the other computer must accept connections from the IP
    address of the electrs server. You can find your computer's IP address using the
    Parmanode menu (startup --> tools --> what's my IP). 

    Then, you need to add the following line to the bitcoin.conf file on that 
    computer: 
$green
                            rpcallowip=IP_address
$orange
    Obviously, replace \"IP_address\" with the actual IP address of the electrs 
    computer.

    And remember to restart Bitcoin for configuration files changes to take effect.

########################################################################################
"
enter_continue
return 0
}

