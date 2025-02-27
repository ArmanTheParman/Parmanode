function menu_main {
debug "Pausing here. IP: $IP" "silent" #when debugging, I can check for error messages and syntax errors
unset enter_cont choice version

while true ; do
set_terminal

source $pn/version.conf >$dn
source $hm >$dn 2>&1 #hide messages
if [[ $vPatch -gt 9 ]] ; then space="" ; else space=" " ; fi #in case version num_er is high, adjust menu border

cd $pn >$dn

branch="$(git status | head -n1 | awk '{print $3}')"
if [[ $branch != master && -n $branch ]] ; then
output_branch="${pink}WARNING: You are on the $branch branch.                        $orange"
else
output_branch="   $space $orange"
fi

if [[ $debug = 1 ]] ; then
debugstatus="#${red}    Debug mode is on$orange                                                                  #"
else
debugstatus="#                                                                                      #"
fi

if check_for_partial_installs ; then
    export partial_install="${red}Warning: You have partially installed programs. See Remove menu.$orange"
else
    #if no partial installs, realestate for the message will be the IP address
    if [[ $OS == "Mac" ]] ; then 
        ComputerName="Mac" 
        desktopfile="$HOME/Desktop/run parmanode shortcut.command"
    else 
        ComputerName=$(cat /etc/hostname) 
        desktopfile="$HOME/Desktop/run parmanode shortcut.sh"
        if [[ $(cat /etc/hostname | wc -c) -gt 14 ]] ; then ComputerName="Computer" ; fi
    fi

    partial_install="                                               $ComputerName IP: $IP"
fi


if ! grep -q "hide_desktop_icon=1" $hm && [[ ! -e $desktopfile ]] && ! lsb_release -a 2>/dev/null | grep -q Ubuntu ; then
icon="\n#$cyan    (icon)$orange               ${pink}Add Desktop Shortcut     (dx to hide) $orange                       #
#                                                                                      #"
else
unset icon
fi

# if statements in the menu printout makes the menu dynamic, ie changes according to the
# tests performed. Variables are set to assist logic in the menu choice execution part
# of the code at the bottom.
set_terminal 49
echo -en "$orange
########################################################################################
#                                                                                      #
#    P A R M A N O D E                \033[4m${bright_blue}MAIN MENU\033[0m$orange                                        #
#                                                                                      #
#    Version:$bright_blue $version     $output_branch \033[88G#
"
echo -e "$debugstatus
########################################################################################
#    $partial_install \033[88G#
#                                                                                      #
#$green    (add)    $orange            Add more Programs                                            #
#                                                                                      #
#$cyan    (u)            $orange      Use Installed Programs                                       #
#                                                                                      #
#$red    (remove)     $orange        Remove/Uninstall Programs                                    #
#                                                                                      #
#$cyan    (ns)$orange                 ${yellow}Navigation shortcuts      $orange                                   #
#                                                                                      #
#$cyan    (dm)$orange                 ${yellow}Parmanode drive menu      $orange                                   #
#                                                                                      #$icon
#                                                                                      #
#--------------------------------------------------------------------------------------#
#                                                                                      #
#                                                                                      #
#$cyan                (h)$orange               Parman's Services/Products/${bright_blue}Help$orange                     #
#$cyan                (t)$orange               Tools                                               #
#$cyan                (s)$orange               Settings/Colours                                    #
#$cyan                (e)$orange               Education                                           #
#$cyan                (d)$orange               Donate                                              #
#$cyan                (log)$orange             See logs and files                                  #
#$cyan                (update)$orange          Update Parmanode                                    #
#$cyan                (uc)$orange              Update Computer                                     #
#$red                (uninstall)$orange       Uninstall Parmanode                                 #
#$cyan                (ap)$orange              About Parmanode                                     #
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
m|M) continue ;;
q|Q) exit ;;
ns) navigation_shortcuts ;;
dm) menu_drives ;;
aa)
if [[ $announcements == off ]] ; then
nogsedtest
sudo gsed -i "/announcements=/d" $hm 
echo "announcements=on" | tee -a $hm 
else
nogsedtest
sudo gsed -i "/announcements=/d" $hm 
echo "announcements=off" | tee -a $hm
fi
;;
h|help)
    get_parmans_help
    ;;
add|Add|ADD)
    menu_add
    ;;
use|USE|Use|u|U)
    menu_use
    ;;
remove|REMOVE)
    menu_remove ;;
l|L|log) 
    menu_log_config ;;
icon)
    [[ ! -e $desktopfile ]] || { invalid && continue ; }
    desktop_icon ;;
dx)
    echo "hide_desktop_icon=1" >> $hm ;;
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

uc)
if [[ $OS == Mac ]] && which brew >/dev/null 2>&1 ; then
yesorno "This could take a seriously long time. Do it?" || continue
fi
update_computer
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

function navigation_shortcuts {
set_terminal_custom 46 ; echo -e "
########################################################################################
$red$blinkon
                               G O O D   N E W S  ! ! $blinkoff$orange

########################################################################################


    I have made it much easier to move around. You can still use the old way of
    course, but now you can jump around to where you want to go if you remember the
    commands.

    Eg, for menu bitcoin, you can type:
    $green
                        mb$orange    or$green   mbitcoin$orange

    for menu electrs:
                $green
                        mers$orange  or$green    melectrs$orange

    To see all the possilble shortcuts, have a look at the code (type$cyan 'code'$orange) and
    $cyan<enter>$orange from here... no, actually, almost from anywhere - nice huh?

    To read any function within Parmanode, type$cyan readfunction$orange from 
    almost anywhere and follow prompts.

    As an example, where you see...
$cyan
                ubitcoin|ub|mbitcoin|mb)
                    if grep -q "bitcoin-end" \$ic ; then
                        menu_bitcoin
                        invalid_flag=set
                    else return 1
                    fi
                ;;
$orange
    ... this means if you type 'mbitcoin' or 'ub' etc, then the code below, up to the 
    ;; will execute. It says if the text 'bitcoin-end' exists in the ic file
    (short for installed.conf), then menu_bitcoin will run, followed by the setting 
    a flag, which is just a signal for a different part the code to know where to go
    next. The 'else' part means to exit if bitcoin-end doesn't exist. 

########################################################################################
"
enter_continue ; jump $enter_cont 
set_terminal ; echo -e "
########################################################################################

    BUT WAIT! There's more.

    You can jump straight to the menu of your choice from the command line. Eg...$cyan

    rp mb$orange ... to get you straigh to the Bitcoin menu.

    or
$cyan
    rp mbtcp$orange ... to get you straight to the BTCPay menu.
$yellow

    The usual pre main-menu screens may come up, and you can to dismiss them
    permanently in the usual way if you want more speed.
$orange
########################################################################################
"
enter_continue ; jump $enter_cont
return 0
}


#    For now, you can jump to any installed app's menu. Later, installing and
#    uninstalling and other menu jumps will become available.

function check_for_partial_installs {

if menu_remove print | grep -q partial ; then
return 0
else
return 1
fi

}