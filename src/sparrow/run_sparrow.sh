function run_sparrow {

if [[ $OS == "Linux" ]] ; then
nohup $HOME/parmanode/Sparrow/bin/Sparrow >$dn 2>&1 & 
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
enter_continue ; jump $enter_cont

}