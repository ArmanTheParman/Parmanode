function run_sparrow {
if [[ $OS == "Linux" ]] ; then
nohup $HOME/parmanode/Sparrow/bin/Sparrow >/dev/null 2>&1 & 
please_wait
sleep 2
fi

if [[ $OS == "Mac" ]] ; then 
open /Applications/Sparrow.app
fi
}