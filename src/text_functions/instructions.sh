function instructions {

if [[ -f $HOME/.parmanode/hide_messages.conf ]] ; then
. $HOME/.parmanode/hide_messages.conf >/dev/null
fi

if [[ ${message_instructions} != "1" ]] ; then 
set_terminal ; echo "
########################################################################################

                                    Instructions

    You can navigate the Parmanode menu system by typing the letters corresponing to 
    the choice you want to make, and hit <enter>. You can always go back up the 
    menu \"tree\" by hitting \"p\" and <enter>. Similarly, you can quit at most
    menus with \"q\" and <enter>. Anternatively, you can exit by holding <control>
    and hitting \"c\".

    The first thing you need to do to use Parmanode is to \"install\" it (there's 
    an option for that in the main menu - you can't miss it). This will create 
    the necessary directory structure on your system.

    Only then you will be able to add individual programs from the \"add\" menu.

    There are many programs available - you don't need to install them all.

    To use any program you've installed, select \"use\" option from the main menu. 
    For each program there are various functions you can select. These are included 
    as ways for you to interact with the installed software in an easy way. 

########################################################################################
    
To hide this message next time, type in \"Free Ross\" then <enter>.

To read about why you should run a node at all, (Parman's 6 reasons to run a node)
type \"node\" and <enter>.


To continue on to the main menu, just hit <enter>.
"
read choice
case $choice in 
"Free Ross"|"free ross"|"free Ross") hide_messages_add "instructions" "1" ; set_terminal ;;
node|NODE|Node) 6reasons_node ;;
esac
fi
return 0
}
