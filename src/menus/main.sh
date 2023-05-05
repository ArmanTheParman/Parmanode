function menu_main {
while true ; do
set_terminal_bit_higher
echo "
########################################################################################
#                                                                                      #
#                           P A R M A N O D E - Main Menu                              #
#                                                                                      #
#                                                                                      #
#         (i)           Install Parmanode ..................(Hint: start here)         #
#                                                                                      #
#         (a)           Add more programs ..........(Can install Bitcoin here)         #
#                                                                                      #
#         (p)           Use programs ...............(Bitcoin, Fulcrum, BTCPay etc)     #
#                                                                                      #
#--------------------------------------------------------------------------------------#
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
#         (ap)          About Parmanode                                                #
#                                                                                      #
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
add|Add| ADD| a |A)
    menu_add_programs ;;
p|P)
    menu_programs ;;
remove|REMOVE)
    remove_programs ;;
l|L) 
    menu_log_config ;;
pp)
    premium ;;
e|E)
    education ;;
t|T)
    PMtools ;;
d|D)
    donations ;;
uninstall|UNINSTALL)
    uninstall_parmanode ;;
ap|AP|Ap|aP)
    about ;;
q | Q | quit)
    exit 0 ;;
*)
    invalid ;;
esac ; done ; return 0
}
