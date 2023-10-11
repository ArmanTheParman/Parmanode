function menu_tools {

while true ; do
set_terminal
echo -e "
########################################################################################
  $cyan
                               P A R M A N O D E - Tools   $orange


              (ip)    What's my computer's IP address?

              (um)    Unmount your Parmanode external drive 
                      (stops Bitcoin/Fulcrum/Electrs if running) - Linux only
     
              (ub)    Migrate an$cyan Umbrel$orange drive to Parmanode 

              (ru)    Migrate a Parmanode drive back to Umbrel

              (mn)    Migrate a${cyan} MyNode${orange} drive to Parmanode 

              (rm)    Migrate a Parmanode drive back to MyNode

              (b)     Bring in a Parmanode drive from another installation, or
                      add a new external drive to Parmanode

              (m)     Mount the Parmanode drive - Linux only
                
              (d)     Delete your previous preference to hide certain Parmanode
                      messages
                 
              (u)     Update computer (Linux or Mac)

              (h)     Check system resources with \"htop\" (installs if needed)

########################################################################################
"
choose "xpq" ; read choice ; set_terminal

case $choice in

    u|U|up|UP|update|UPDATE|Update)
    if [[ $OS == "Linux" ]] ; then sudo apt-get update -y && sudo apt-get upgrade -y ; fi
    if [[ $OS == "Mac" ]] ; then set_terminal ; please_wait ; brew update && brew upgrade ; fi
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

    m|M|mount)
        mount_drive menu
        if mount | grep -q parmanode ; then
        announce "Drive mounted."
        fi
        ;;
    p|P)
        return 0
        ;;

    h|H|htop|HTOP|Htop)

        announce "To exit htop, hit$cyan q$orange"

        if [[ $OS == "Mac" ]] ; then htop ; break ; return 0 ; fi

        if ! which htop ; then sudo apt-get install htop -y >/dev/null 2>&1 ; fi

        htop

        ;;

    ub|UB|Ub)
    umbrel_import 
    ;;

    ru|RU|Ru)
    umbrel_revert
    ;;

mn|MN|Mn)
mynode_import
;;

rm|RM|Rm)
mynode_revert
;;

    b|B|Bring|brin) 
        add_drive menu
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

