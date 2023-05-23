function menu_main {
while true ; do
set_terminal_bit_higher
echo "
########################################################################################
#                                                                                      #
#                           P A R M A N O D E - Main Menu                              #
#                                                                                      #
#                                                                                      #"
if ! grep -q "parmanode" $HOME/.parmanode/installed.conf >/dev/null 2>&1 ; then 
echo "#         (i)           Install Parmanode                                              #"
else
echo "#         (add)         Add more programs                                              #
#                                                                                      #
#         (use)         Use programs ...............(Bitcoin, Fulcrum, BTCPay etc)     #
#                                                                                      #" ; fi

echo "#--------------------------------------------------------------------------------------#
#                                                                                      #
#         (remove)      Remove (uninstall) programs                                    #
#                                                                                      #
#         (l)           See logs and configuration files                               #
#                                                                                      #
#         (pp)          Parmanode Premium                                              #
#                                                                                      #
#         (e)           Education                                                      #
#                                                                                      #
#         (t)           Tools                                                          #
#                                                                                      #
#         (d)           Donate ;)                                                      #
#                                                                                      #
#         (uninstall)   Uninstall Parmanode ..........(Who'd do such a thing?)         #
#                                                                                      #
#         (update)      Update Parmanode                                               #
#                                                                                      #
#         (ap)          About Parmanode                                                #
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
    install_parmanode  ;;
add|Add| ADD)
    menu_add_programs ;;
use|USE|Use)
    menu_programs 
    ;;
remove|REMOVE)
    remove_programs ;;
l|L) 
    menu_log_config ;;
pp)
    premium ;;
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
