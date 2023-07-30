function instructions {

if [[ -f $HOME/.parmanode/hide_messages.conf ]] ; then
. $HOME/.parmanode/hide_messages.conf >/dev/null
fi

if [[ ${message_instructions} != "1" ]] ; then 
set_terminal ; echo "
########################################################################################

                                    Instructions

    The first thing you need to do is install Parmanode (there's an option for that in
    the main menu). This will create the necessary directory structure, and give you
    the option to format an external drive, should you wish to use that.

    Once Parmnode installation is done, you will be able to add individual programs. 
    These are also available from the main menu, under \"add programs\". Start by 
    adding Bitcoin, and work your way down the list. You can add any you like and are
    not obliged to install everything.

    To use any program, select \"use programs\"from the main menu. For each program 
    there are various functions you can select. These are included as ways for you 
    to interact with the installed software in an easy way. There is nothing stopping 
    you from using the programs directly yourself. For example, running \"bitcoin-cli 
    getblockchaininfo\" from the terminal will still work.

    To hide this message next time, type in \"Free Ross\" then <enter>.

    To read about why you should run a node at all, (Parman's 6 reasons to run a node)
    type \"node\" and <enter>.

    To continue on to the main menu, just hit <enter>.

########################################################################################
"
read choice
case $choice in 
"Free Ross"|"free ross"|"free Ross") hide_messages_add "instructions" "1" ; set_terminal ;;
node|NODE|Node) 6reasons_node ;;
esac
fi
return 0
}
