function instructions {

# If the file exists, source it...
# checks named file first: 
#      -f, is 'is it a file?, 
#      -d is 'is it a directory?', 
#      -e is 'does it exist?' 
#      -L is 'is it a symlink?"

# A . is the same as the source command when used like this.

if [[ -f $HOME/.parmanode/hide_messages.conf ]] ; then
. $HOME/.parmanode/hide_messages.conf >/dev/null
fi

#$message_instructions value comes from sourcing. This is a bit too roundabout; I'll change this later.
if [[ ${message_instructions} != "1" ]] ; then 
set_terminal ; echo -e "
########################################################################################$cyan
                               Parmanode Instructions$orange
########################################################################################


    Parmanode is a keyboard controlled program. You navigate by reading menu uptions,
    typing your choice, and hitting $cyan<enter>$orange. The options are usually on the left, 
    with ) or () for visual separation, and text explanation on the right.$magenta 
    
    The mouse does nothing in Parmanode, except to bring the window into focus.$orange 
    
    For example...

$cyan
               y)$orange    Yes, please delete all shitcoin private keys from the comptuer
$red
               n)$orange    No, don't delete anything, I enjoy degeneracy


########################################################################################

    In this case, to destroy all your shitcoin keys, you would type$cyan y$orange, without the ),
    and hit the$cyan <enter>$orange or $cyan<return>$orange key.

    You might be slow at first, but will get faster with time - Parmanode is fast.

########################################################################################

To hide this message next time, type in$pink \"Free Ross\"$orange then <enter>."
enter_continue
if [[ $enter_cont == "Free Ross" || $enter_cont == "free ross" ]] ; then hide_messages_add "instructions" "1" ; set_terminal 
fi

set_terminal ; echo -e "
########################################################################################$cyan
                               Parmanode Instructions II$orange
########################################################################################

$red
              TO START USING PARMANODE, FROM THE MAIN MENU, YOU CAN:
$cyan
    1.$orange Add individual programs from the$green \"add\"$orange menu.
$cyan
    2$orange. Access programs from the$green use menu$orange 
$cyan       
    3$orange. Recommendation - Explore all the options from the main menu, there are 
       hidden gems.
$cyan
    4$orange. Recommendation - Regularlay update Parmanode (the best way is from the Parmanode
       menu). 
$orange

########################################################################################
    
To hide this message next time, type in$pink \"Free Ross\"$orange then <enter>.

To continue on to the main menu, just hit$cyan <enter>${orange}.
"
read choice
case $choice in 
q|Q)
   exit ;;
d|D) 
   if [[ -z $debug ]] ; then export debug=1 ; else unset debug ; fi
;;
   "Free Ross"|"free ross"|"free Ross") 
   hide_messages_add "instructions" "1" ; set_terminal 
;;
esac
fi
set_terminal
return 0
}
