function run_specter {
if [[ $OS == "Linux" ]] ; then
nohup $HOME/parmanode/specter/*AppImage* >/dev/null 2>&1 & 
please_wait
sleep 2
fi

if [[ $OS == "Mac" ]] ; then 
open /Applications/*pecter.app
fi
}