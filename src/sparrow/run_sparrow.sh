function run_sparrow {

while true ; do
if [[ -e $dp/.sparrow_first_run ]] ; then break ; fi
set_terminal ; echo -e "
########################################################################################

    Parmanode detected this is the first time you are running Sparrow since its
    install.

    In order for the connection to your node to work, for an unexplainable reason,
    Sparrow needs to start, shutdown, then start again.
$cyan
    After Sparrow loads, please shut it down, then come back here to start it again.
$orange
########################################################################################
"
enter_continue
touch $dp/.sparrow_first_run >/dev/null 2>&1
break
done

if [[ $OS == "Linux" ]] ; then
nohup $HOME/parmanode/Sparrow/bin/Sparrow >/dev/null 2>&1 & 
please_wait
sleep 2
fi

if [[ $OS == "Mac" ]] ; then 
open /Applications/Sparrow.app
fi

set_terminal ; echo -e "
########################################################################################
$cyan
   Sparrow$orange will open in a moment in it's own window. You can continue to use
   Parmanode as normal, or minimise it. 

########################################################################################
"
enter_continue

}