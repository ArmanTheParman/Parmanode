function menu_main {
while true ; do
set_terminal_bit_higher
echo "
########################################################################################
#                                                                                      #
#    P A R M A N O D E -- Main Menu                                                    #
#                                                                                      #
########################################################################################
#                                                                                      #"
if ! grep -q "parmanode" $HOME/.parmanode/installed.conf >/dev/null 2>&1 ; then parmanodemain=1
echo "#    (i)                  Install Parmanode                                            #"
else parmanodemain=0
echo "#    (add)                Add more programs (Install menu)                             #
#                                                                                      #
#    (use)                Use programs (Apps menu)........(Bitcoin, Sparrow, etc)      #
#                                                                                      #" ; fi

echo "#--------------------------------------------------------------------------------------#
#                                                                                      #
#    (remove)             Remove (uninstall) programs                                  #
#                                                                                      #
#    (l)                  See logs and configuration files                             #
#                                                                                      #
#    (e)                  Education                                                    #
#                                                                                      #
#    (t)                  Tools                                                        #
#                                                                                      #
#    (d)                  Donate ;)                                                    #
#                                                                                      #
#    (uninstall)          Uninstall Parmanode ..........(Who'd do such a thing?)       #
#                                                                                      #
#    (update)             Update Parmanode                                             #
#                                                                                      #
#    (ap)                 About Parmanode                                              #
#                                                                                      #
########################################################################################
"
choose "xq"
echo "
(Note, <enter> is the same as <return>)"
read choice
set_terminal

case $choice in

i|I)
    if [[ $parmanodemain == 1 ]] ; then
    install_parmanode 
    fi
    ;;
add|Add| ADD)
    if [[ $parmanodemain == 0 ]] ; then
    menu_add_programs
    fi
    ;;
use|USE|Use)
    if [[ $parmanodemain == 0 ]] ; then
    menu_programs 
    fi 
    ;;
remove|REMOVE)
    remove_programs ;;
l|L) 
    menu_log_config ;;
e|E)
    education ;;
t|T)
    menu_tools ;;
d|D)
    donations ;;
uninstall|UNINSTALL)
    uninstall_parmanode ;;
update|UPDATE|Update)
    update_parmanode ;;
ap|AP|Ap|aP)
    about ;;
q | Q | quit)
    exit 0 ;;
*)
    invalid ;;
esac ; done ; return 0
}
