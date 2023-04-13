function menu_install {

while true
do
set_terminal
echo "
########################################################################################

                                   P A R M A N O D E


                    i)          Install Parmanode ......... (Must install first)

                    u)          Uninstall Parmanode

                    pp)         Parmanode Premium

                    a)          Add more programs ......... (Can install Bitcoin here)

                    r)          Remove programs

                    ip)         What's my computer's IP address?

########################################################################################
"
choose "xpq"

read choice

case $choice in
i)
    set_terminal
    install_parmanode ; if [$? == 0 ] ; then return 0 ; fi 
    continue
    ;;
u)
    set_terminal
    uninstall_parmanode
    continue
    ;;
pp)
    set_terminal
    premium
    continue
    ;;
a)
    set_terminal
    menu_add_programs
    return 0;;
r|R)
    remove_programs
    continue
    ;;
ip|IP|iP|Ip)
    IP_address
    continue
    ;;
quit | QUIT | q | Q)
    exit 0
    ;;
p | P)
    return 0
    ;;
*)
    clear
    invalid #echo and confirm function. frequently used.
    continue;
    ;;

esac

done
return 0
}
