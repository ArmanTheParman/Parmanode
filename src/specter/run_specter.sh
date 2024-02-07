function run_specter {
if [[ $OS == "Linux" ]] ; then
nohup $HOME/parmanode/specter/*AppImage* >/dev/null 2>&1 & 
please_wait
sleep 2
fi

if [[ $OS == "Mac" ]] ; then 
open /Applications/*pecter.app
fi

set_terminal ; echo -e "
########################################################################################
$cyan
   Specter$orange will open in a moment in it's own window. You can continue to use
   Parmanode as normal, or minimise it. 

########################################################################################
"
enter_continue

}