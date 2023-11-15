function bre_warnings {
echo -e "
########################################################################################

    Please make sure that Bitcoin Core has finished syncing before concluding if BRE 
    is working or not.

    Also, you may see the message when trying to load BRE:
   $red 
      'This explorer currently is failing to connect to your Bitcoin Core node.'
   $green 
    This is normal$orange - give it 15 minutes or so, even if your node is fully sync'ed.

########################################################################################
"
enter_continue
}