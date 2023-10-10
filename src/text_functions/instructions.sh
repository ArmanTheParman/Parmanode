function instructions {

if [[ -f $HOME/.parmanode/hide_messages.conf ]] ; then
. $HOME/.parmanode/hide_messages.conf >/dev/null
fi

if [[ ${message_instructions} != "1" ]] ; then 
set_terminal ; echo -e "
########################################################################################

                               $cyan     Instructions$orange

    1. The first thing you need to do to use Parmanode is to$green \"install\"$orange it 
       (there's an option for that in the main menu - you can't miss it). 

    2. Add individual programs from the$green \"add\"$orange menu. You don't need to install them 
       all.

    3. Use programs from the$green \"use\"$orange menu. 

    4. Each program has its$green own menu$orange nested under the \"use\" menu; various 
       functions are available for you to make it easier to interact with the program.
       
    5. If you$green update$orange Parmanode (easiest way is from the menu) the programs Parmanode
       has installed for you won't be changed. To get newer version of installed
       programs, use Parmanode to uninstall the program, then re-install using 
       Parmanode. The updated script will install the newer version for you.

########################################################################################
    
To hide this message next time, type in$pink \"Free Ross\"$orange then <enter>.

To read about why you should run a node at all, (Parman's 6 reasons to run a node)
type$pink \"node\"$orange and <enter>.

To continue on to the main menu, just hit$cyan <enter>${orange}.
"
read choice
case $choice in 
"Free Ross"|"free ross"|"free Ross") hide_messages_add "instructions" "1" ; set_terminal ;;
node|NODE|Node) 6reasons_node ;;
esac
fi
return 0
}
