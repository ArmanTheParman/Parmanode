function menu_main {
while true ; do
set_terminal

source $pn/version.conf >/dev/null
source $hm >/dev/null 2>&1 #hide messages
if [[ $vPatch -gt 9 ]] ; then space="" ; else space=" " ; fi #in case version number is high, adjust menu border

branch="$(git status | head -n1 | awk '{print $3}')"
if [[ $branch != master && -n $branch ]] ; then
output_branch="${pink}WARNING: You are on the $branch branch.                        $orange"
else
output_branch="   $space                                                         $orange#"
fi

set_terminal_custom 51
if [[ $debug = 1 ]] ; then
debugstatus="#${red}    Debug mode is on$orange                                                                  #"
else
debugstatus="#                                                                                      #"
fi

# if statements in the menu printout makes the menu dynamic, ie changes according to the
# tests performed. Variables are set to assist logic in the menu choice execution part
# of the code at the bottom.
echo -en "$orange
########################################################################################
#                                                                                      #
#    P A R M A N O D E     ${bright_blue}Main Menu$orange                                                   #
#                                                                                      #
#    Version:$bright_blue $version     $output_branch
#                                                                                      #
"
echo -e "$debugstatus
########################################################################################
#                                                                                      #
#                                                                                      #
#$green    (add)    $orange            Add more Programs                                            #
#                                                                                      #
#$cyan    (u)            $orange      Use Installed Programs                                       #
#                                                                                      #
#$red    (remove)     $orange        Remove/Uninstall Programs                                    #
#                                                                                      #
#$cyan    (o)$orange                  Overview/Status of Programs                                  #
#                                                                                      #
#$cyan    (h)$orange                  ${yellow}${blinkon}HINTS (new)$blinkoff$orange                                                  #
#                                                                                      #
#--------------------------------------------------------------------------------------#
#                                                                                      #
#$cyan    (t)        $orange          Tools                                                        #
#                                                                                      #
#$cyan    (s)              $orange    Settings/Colours                                             #
#                                                                                      #
#$cyan    (mm)$orange                 Mentorship with Parman - Info                                #
#                                                                                      #
#$cyan    (e)       $orange           Education                                                    #
#                                                                                      #
#$cyan    (d)             $orange     Donate                                                       #
#                                                                                      #
#$cyan    (log) $orange               See logs and config files                                    #
#                                                                                      #
#$cyan    (update)  $orange           Update Parmanode                                             #
#                                                                                      #
#$red    (uninstall)     $orange     Uninstall Parmanode                                          #
#                                                                                      #
#$cyan    (ap)$orange                 About Parmanode                                              #
#                                                                                      #
#                                                                                      #
########################################################################################

 Type your$cyan choice$orange without the brackets, and hit$green <enter>$orange 
 Or to quit, either hit$green <control>-c$orange, or type$cyan q$orange then$green <enter>$orange.
"
if [[ ! $announcements == off ]] ; then
echo -e "
 Tip: combine u with the next menu options. eg, try ub for bitcoin menu

$blinkon$red                   WARNING!! YOU DON'T HAVE ENOUGH BITCOIN $orange$blinkoff"
fi

read choice #whatever the user chooses, it gets put into the choice variable used below.
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in #the variable choice is tested through each of the case-choices below.
# these end in a closing bracket, have some code, and end with a ;;
# once there is a match, the case block is exited (after the esac point below). Then
# it repeats because case is inside a while loop.

q|Q) exit ;;
h) hints ;;
aa)
if [[ $announcements == off ]] ; then
sudo gsed -i "/announcements=/d" $hm 
echo "announcements=on" | tee -a $hm 
else
sudo gsed -i "/announcements=/d" $hm 
echo "announcements=off" | tee -a $hm
fi
;;
o|O)
menu_overview 
;;

a|add|Add|ADD)
    menu_add
    ;;
use|USE|Use|u|U)
    menu_use
    ;;
remove|REMOVE)
    menu_remove ;;
l|L) 
    menu_log_config ;;
mm|MM)
     mentorship
     ;;

e|E)
    menu_education ;;
t|T)
    menu_tools ;;
s|S)
    menu_settings ;;
d|D)
    sned_sats ;;
un|uninstall|UNINSTALL)
uninstall_parmanode
;;
up|update|UPDATE|Update)
    update_parmanode || continue
    if [[ $main_loop != 0 ]] ; then
    set_terminal ; 
    announce "You need to exit and reload Parmanode to use the new version of Parmanode."
    continue
    fi
    # The user has been alerted to needing to restart Parmanode for the changes to take effect.
    # Setting exit_loop to false allows the program to continue without forcing an exit.
    if [[ $exit_loop == "false" ]] ; then return 0 ;fi
;;
ap|AP|Ap|aP)
    about ;;

uany) menu_use any ;; 
ub) menu_use b ;; 
ubb) menu_use bb ;;
ubre) menu_use bre ;; 
ubtcp) menu_use btcp ;;
ue) menu_use e ;;
uers) menu_use ers ;;
uf) menu_use f ;;
ul) menu_use l ;; 
ulnb) menu_use lnb ;;
ut) menu_use t ;;
us) menu_use s ;;
ur) menu_use r ;;
uts) menu_use ts ;;
ubtcpt) menu_use btcpt ;; 
us) menu_use s ;;
utrz) menu_use trz ;;
ull) menu_use ll ;;
ups) menu_use ps ;;
upbx) menu_use pbx ;;
upih) menu_use pih ;;
uqbit) menu_use qbit ;;
umem) menu_use mem ;;
uersd) menu_use ersd ;;
upool) menu_use pool ;;
uex) menu_use ex ;;
uth) menu_use th ;;
unr) menu_use nr ;;
ulitd) menu_use litd ;;
ult) menu_use lt ;;
unext) menu_use next ;;


ul|UL|Ul)
clear ; please_wait
menu_lnd
;;

debugon) 
export debug=1 ;;
debugoff) 
export debug=0 ;;

*)
invalid ; clear ;;

esac ; done ; return 0
}

function hints {
set_terminal ; echo -e "
########################################################################################
$red$blinkon
                               G O O D   N E W S  ! ! $blinkoff$orange

########################################################################################


    I have made it much easier to move around. You can still use the old way of
    course, but now you can jump around to where you want to go if you remember the
    commands.

    You can type 'm' (for menu) and the abbreviation or full name of the program. 
    

    Eg, for bitcoin, you can type:
$green
                    mb$orange    or$green   mbitcoin$orange

   for electrs:
            $green
                    mers$orange  or$green    melectrs$orange
$pink    
    Enjoy
$orange
########################################################################################
"
enter_continue
jump $enter_cont 
return 0
}


#    For now, you can jump to any installed app's menu. Later, installing and
#    uninstalling and other menu jumps will become available.
