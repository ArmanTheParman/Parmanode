function screen_video_recording {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi
if [[ $computer_type == "Pi" ]] ; then announce "Not available for Pi yet." ; return 1 ; fi

which ffmpeg >$dn || { sudo apt-get update -y && sudo apt-get install ffmpeg -y ; }

num=1
        
while [[ -e $HOME/Desktop/video_$num.mp4 ]] ; do num=$((num + 1)) ; done


announce "Hit$cyan <enter>$orange to start recording your screen. Minimise
    the terminal and start doing stuff that you want to record.
$red
    Once finished, come back to this terminal and hit$blue q$red to stop recording 
    and finalise the file. Then you can trim it how you want. $orange
    
    The file will be saved to$cyan $HOME/Desktop/video_$num.mp4$orange"

ffmpeg -video_size 1920x1080 -framerate 30 -f x11grab -i $DISPLAY $HOME/Desktop/video_$num.mp4

enter_continue

}

