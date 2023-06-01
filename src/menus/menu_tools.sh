function menu_tools {

while true ; do
set_terminal
echo "
########################################################################################
 
                                P A R M A N O D E - Tools

                    
                 (u)     Update computer (Linux or Mac)

                 (ip)    What's my computer's IP address?

                 (d)     Delete your previous preference to hide certain Parmanode
                            messages

                 (h)     Check system resources with \"htop\" (installs if needed)

                 (a)     Add a new external drive to parmanode


                 ... More soon

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
        echo "Choices reset" ; sleep 0.6 ;;
    p|P)
        return 0
        ;;
    h|H|htop|HTOP|Htop)
        if [[ $OS == "Mac" ]] ; then htop ; break ; fi

        if ! which htop ; then sudo apt install htop -y >/dev/null 2>&1
        else
        nohup gnome-terminal -- bash -c "htop"
        fi
        ;;
    a|A|add|ADD|Add)
        add_drive 
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
