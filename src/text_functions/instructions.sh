function instructions {
. $HOME/.parmanode/hide_messages.conf >/dev/null

if [[ $message_instructions != "1" ]] ; then 
set_terminal ; echo "
########################################################################################

                                    Instructions

    The first thing you need to do is install Parmanode (there's an option for that in
    the main menu). This will createt he necessary directory structure, and give you
    the option to format an external drive, should you wish to use that.

    Once that is done, you can add individual programs. That is also available from
    the main menu, under \"add programs\". Start with Bitcoin, and work your way
    down.

    To use functions for each of the programs, from the main menu, select \"use 
    programs\". For each program there are various functions you can select. These
    are just ways for you to interact with the installed software in an easy way. There
    is nothing stopping you from using the programs directly yourself. For example,
    running \"bitcoin-cli getblockchaininfo\" from the terminal will still work.

    To not see this menu again, type in \"Free Ross\" then <enter>.

########################################################################################
"
choose "xpq" ; read choice
case $choice in 
"Free Ross"|"free ross"|"free Ross") hide_messages_add "instructions" "1" ;;
esac
fi
return 0
}