function run_sparrow {
if [[ $OS == "Linux" ]] ; then

debug "1"
nohup $HOME/parmanode/Sparrow/bin/Sparrow >/dev/null 2>&1 & 
please_wait
sleep 2
fi

debug "1"
if [[ $OS == "Mac" ]] ; then 
open /Applications/Sparrow.app
fi
}