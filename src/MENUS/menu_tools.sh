function menu_tools 
# add soon...
#                 (z)     Flash a microSD card with Pi OS for ParmaZero
#

while true ; do
set_terminal
echo -e "
########################################################################################
 
                      $cyan          P A R M A N O D E - Tools   $orange

                    
                 (u)     Update computer (Linux or Mac)

                 (ip)    What's my computer's IP address?

                 (d)     Delete your previous preference to hide certain Parmanode
                            messages

                 (h)     Check system resources with \"htop\" (installs if needed)

                 (a)     Bring in a Parmanode drive from another installation, or
                         add a new external drive to Parmanode
                
                 (x)     Block data compatibility with other computers


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
        echo "Choices reset" ; sleep 0.6 
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

    a|A|add|ADD|Add)
        add_drive 
        ;;
    
    x|X) compatibility
        ;;

    q|Q|Quit|QUIT)
        exit 0
        ;;
#    z|Z)
#        install_ParmaZero
#        ;;
    "")
        return 0 
        ;;

    *)
        invalid 
        ;;
    esac
done
return 0


