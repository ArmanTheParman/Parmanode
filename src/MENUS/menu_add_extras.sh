function menu_add_extras {
while true ; do
menu_add_source
if [[ -e $hp/parman_books ]] ; then UPDATE="${red}UPDATE$orange " ; endline="                 #" ; else unset UPDATE ; endline="                        #"; fi
set_terminal
echo -en "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> Install Menu  -->$cyan Extras        $orange              #
#                                                                                      #
########################################################################################
#                                                                                      #
#                                                                                      #
#$cyan              (rr)$orange      RAID - join drives together                                   #
#                                                                                      #
#$cyan              (h)$orange       HTOP - check system resources                                 #
#                                                                                      #
#$cyan              (udev)$orange    Add UDEV rules for HWWs (only needed for Linux)               #
#                                                                                      #
#$cyan              (fb)$orange      ${UPDATE}Parman's recommended free books (pdfs)$endline
#                                                                                      #
#$cyan              (cl)$orange      Core Lightning                                                #
#                                                                                      #
#$cyan              (sr)$orange      Screen Video Recording                                        #
#                                                                                      #
#$cyan              (pm)$orange      ParMiner                                                      #
#                                                                                      #
#                                                                                      #
########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 0 ;; m|M) back2main ;;

rr)
    install_raid 
    return 0
;; 

h|H|htop|HTOP|Htop)

    if [[ $OS == "Mac" ]] ; then htop ; break ; return 0 ; fi
    if ! which htop ; then sudo apt-get install htop -y >$dn 2>&1 ; fi
    announce "To exit htop, hit$cyan q$orange"
    htop
;;

udev|UDEV)

    if grep -q udev-end $dp/installed.conf ; then
    announce "udev already installed."
    return 0
    fi
    udev
;;
fb|FB)
get_books
;;

cl)
announce "Parmanode isn't configured to support Core Lightning, but it can install it for
    you. This means that any conflicts with other Parmanode-installed software will 
    not be checked for or managed.

    To install Core Lightning, it is recommended you uninstall LND, make sure Bitcoin 
    is installed and running, then exit parmanode and restart it with this command: $cyan

            rp install_core_lightning
    $orange
    To uninstall, do:$cyan
            
            rp uninstall_core_lightning
    $orange
    This will start the installation, and will get you to hit <enter> at various 
    stages, as it downloads files and compiles from source.

    There won't be any menus in Parmanode, you'll need to interact with it by the 
    command line or other means. Core Lightning may be implemende within Parmanode in 
    the future." 
;;
pm)
get_parminer
;;

sr)
screen_video_recording
;;

*)
    invalid
    continue
    ;;
esac
done

return 0

}



function screen_video_recording {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

which ffmpeg >$dn || { sudo apt-get update -y && sudo apt-get install ffmpeg -y ; }

num=1
	
while [[ -e $HOME/Desktop/video_$num ]] ; do num=$((num + 1)) ; done


announce "Hit <enter> to start recording your screen. File will be saved to $HOME/Desktop/video_$num
$red
    Once finished, hit <q> to stop recording and finalise the file. Then you can trim 
    it how you want. $orange"
ffmpeg -video_size 1920x1080 -framerate 30 -f x11grab -i :0.0 $HOME/Desktop/video_$num

enter_continue

}
