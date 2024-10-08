function menu_tools {

while true ; do
set_terminal_high
echo -e "
########################################################################################
  $cyan
                                  TOOLS - PAGE 1  $orange


$cyan              (cc)$orange    Upgrade ColdCard firmware wizard             

$cyan              (d)$orange     Delete your previous preferences to hide certain Parmanode
                      messages

$cyan              (dfat)$orange  Drive format assist tool
 
$cyan              (md)$orange    Import/Migrate/Revert an external drive.

$cyan              (mm)$orange    Mount the Parmanode drive - Linux only

$cyan              (ip)$orange    What's my computer's IP address?

$cyan              (ppp)$orange   Connect to Parman's node over Tor ...

$cyan              (pn)$orange    ParmanodL - Flash a mircoSD for a Raspberry Pi
                                                                                      
$cyan              (ps)$orange    ParmaShell info 

$cyan              (rs)$orange    Parman's easy AF Rsync tool new

$cyan              (u)$orange     Update computer (apt-get for Linux, Homebrew for Macs)

$cyan              (um)$orange    Unmount your Parmanode external drive 
                      (stops Bitcoin/Fulcrum/Electrs if running) - Linux only
$red $blinkon
         ...  (n)  More options $blinkoff
$orange
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal

case $choice in
    n|next)
    menu_tools2
    ;;
    
    m|M) back2main ;;

    cc)
    colcard_firmware
    ;;

    ppp|PPP)

    connect_to_parman
    ;;

    pn|PN|Pn)
    get_parmanodl
    ;;

    ps|PS|Ps)
    parmashell_info
    return 0
    ;;

    u|U|up|UP|update|UPDATE|Update)
    if [[ $OS == "Linux" ]] ; then 
        sudo apt-get update -y && sudo apt-get upgrade -y 
        sudo apt-get --fix-broken install -y
        enter_continue
        success "Your computer" "being updated"
    fi
    if [[ $OS == "Mac" ]] ; then 
        please_wait 
        brew_check || continue 
        brew update ; brew upgrade 
        enter_continue
        success "Your Mac" "being updated"
        if [[ $bashV_major -lt 5 ]] ; then brew install bash ; fi
    fi
    ;;

    ip|IP|iP|Ip)
        IP_address
        return 0
        ;;
    d|D)
        rm $HOME/.parmanode/hide_messages.conf
        echo "Choices reset" ; sleep 0.6 
        ;;
    um|UM|Um)
        safe_unmount_parmanode menu
        ;;

    mm|MM|Mm|mount)
        mount_drive menu
        if mount | grep -q parmanode ; then
        announce "Drive mounted."
        fi
        ;;
    p|P)
        return 0
        ;;

      md|MD)
      menu_migrate
      ;;

      rs|RS)
      rsync
      ;;

      dfat|DFAT)
      format_assist
      ;;

      q|Q|Quit|QUIT)
        exit 0
        ;;
    "")
        return 0 
        ;;

    *)
        invalid 
        ;;
    esac
done
return 0
}

function connect_to_parman {

set_terminal ; echo -e "
########################################################################################
$cyan
                            CONNECT TO PARMAN'S NODE
$orange
    This is for emergency or testing purposes only. What's the point of having a node
    if you're going to connect to someone else's?

    Nevertheless, this option is available to you, just in case. I can't promise
    100% up time, because someitmes shit happens. If for whatever reason, my connection
    details change, it will be renewed in Parmanode when you update Parmanode.

    I promise to not collect any data or spy on your transactions. I can confidently
    make that promise because I don't even know how to do that. Your IP address will
    be unknown because you're connecting over Tor anyway.
    
    You'll have to manually tweak your wallet settings and include the following 
    onion address to connect to my server:
$green
    ail3y746ukjgowb2l4izovsh2tzyre4ohxii7rwes3j5ggx6pc3cvdid.onion:700${red}4$green:t 

$orange
    You must use the port number after the onion address or you can't connect.

    For Electrum wallet, you must turn on your Tor proxy, and you must add the \":t\"
    part of the the 7002 port. This specifies TCP over Tor. (:s, for SSL won't work.)

    For Sparrow wallet, you must have SSL turned off, and you must have the Tor proxy
    turned on.

########################################################################################
"
enter_continue

}
