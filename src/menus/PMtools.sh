function PMtools {

while true ; do
set_terminal
echo "
########################################################################################
 
                                P A R M A N O D E - Tools

                    
                    (ip)    What's my computer's IP address?

                    (d)     Delete your previous choices to hide Parmanode messages



                    ... More soon

########################################################################################
"
choose "xpq" ; read choice ; set_terminal

case $choice in

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
