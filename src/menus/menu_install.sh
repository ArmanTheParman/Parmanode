function menu_install {

while true
do
set_terminal
echo "
########################################################################################

                            P A R M A N O D E - Install Menu


                    (i)        Install Parmanode ....... (Must install first)

                    (u)        Uninstall Parmanode

                    (a)        Add more programs ....... (Can install Bitcoin here)

                    (r)        Remove programs

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
a)
    set_terminal
    menu_add_programs
    return 0;;
r|R)
    remove_programs
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
