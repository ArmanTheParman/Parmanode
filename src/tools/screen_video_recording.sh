function screen_video_recording {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

num=1 ; while [[ -e $HOME/Desktop/video_$num.mp4 ]] ; do num=$((num + 1)) ; done

if echo $XDG_SESSION_TYPE | grep -q "wayland" ; then        
    which slurp >/dev/null || sudo apt-get install slurp -y || { enter_continue "Something went wrong." ; return 1 ; }
    which wf-recorder >/dev/null || sudo apt-get install wf-recorder -y || { enter_continue "Something went wrong." ; return 1 ; }
    svr_announce
    wf-recorder -g "$(slurp)" -f "$HOME/Desktop/video_$num.mp4"
else
    which ffmpeg >$dn || { sudo apt-get update -y && sudo apt-get install ffmpeg -y ; }
    svr_announce
    ffmpeg -video_size 1920x1080 -framerate 30 -f x11grab -i $DISPLAY $HOME/Desktop/video_$num.mp4
fi
enter_continue
}



function svr_announce {

if [[ $1 == Pi ]] ; then
text="You'll be prompted to draw a box to record a target region.
    If you don't want that, and prefer the full screen type$green 
    full$orange now.
    "
fi

announce "$text 
    Once recording, minimise the terminal and start doing stuff that you want 
    to record. 

$red
    Once finished, come back to this terminal and hit$blue <control> c$orange 
    to stop recording and finalise the file. Then you can trim it how you want. $orange
    
    The file will be saved to$cyan $HOME/Desktop/video_$num.mp4$orange"
"Hit$cyan <enter>$orange to start recording your screen.