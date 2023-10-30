function menu_main {
while true ; do
set_terminal_bit_higher #custom function to resize the window
source $original_dir/version.conf >/dev/null
if [[ $vPatch -gt 9 ]] ; then space="" else space =" " ; fi
# if statements in the menu printout makes the menu dynamic, ie changes accoring to the
# tests performed. Variables are set to assit logic in the menu choice excution part
# of the code at the bottom.
echo -e "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> ${cyan}Main Menu$orange                                                   #
#    Version:$red $version                                                                $orange  $space #
########################################################################################
#                                                                                      #
#                                                                                      #
#    (add)                Add more programs                                            #
#                                                                                      #
#    (u)                  Use programs                                                 #
#                                                                                      #
#    (remove)             Remove/uninstall programs                                    #
#                                                                                      #
#--------------------------------------------------------------------------------------#
#                                                                                      #
#    (t)                  Tools                                                        #
#                                                                                      #
#    (m)                  Bitcoin Mentorship Info  .... (Study with Parman)            #
#                                                                                      #
#    (pn)                 ParmanodL                                                    #
#                                                                                      #
#    (e)                  Education                                                    #
#                                                                                      #
#    (d)                  Donate ;)                                                    #
#                                                                                      #
#    (l)                  See logs and config files                                    #
#                                                                                      #
#    (update)             Update Parmanode  ........... (Improvements always coming)   #
#                                                                                      #
#    (uninstall)          Uninstall Parmanode  ........ (Who'd do such a thing?)       #
#                                                                                      #
#    (ap)                 About Parmanode                                              #
#                                                                                      #
#                                                                                      #
########################################################################################

 Type your$green choice$orange without the brackets, and hit$green <enter>$orange 

 Or to quit, either hit$green <control>-c$orange, or type$green q$orange then$green <enter>$orange.
"
read choice #whatever the user chooses, it gets put into the choice variable used below.
set_terminal

case $choice in #the variable choice is tested through each of the case-choices below.
# these end in a closing bracked, have some code, and end with a ;;
# once there is a match, the case block is exited (after the esac point below). Then
# it repeats because case is inside a while loop.

add|Add| ADD)
    menu_add_new
    ;;
use|USE|Use|u|U)
    menu_use
    ;;
remove|REMOVE)
    menu_remove ;;
l|L) 
    menu_log_config ;;
m|M)
     mentorship
     ;;
pn|PN|Pn)
    get_parmanodl
    ;;
e|E)
    menu_education ;;
t|T)
    menu_tools ;;
d|D)
    donations ;;
uninstall|UNINSTALL)
uninstall_parmanode
;;
update|UPDATE|Update)
    update_parmanode || continue
    if [[ $exit_loop == false ]] ; then return 0 ;fi
;;
ap|AP|Ap|aP)
    about ;;

ub)
menu_bitcoin_core
return 0 #necessary for "m" function
;;

q | Q | quit)
    exit 0 ;;
*)
    invalid ;;
esac ; done ; return 0
}
