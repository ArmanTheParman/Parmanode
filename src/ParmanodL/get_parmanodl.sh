function get_parmanodl {
while true ; do
set_terminal ; echo -e "
########################################################################################
$green
                                 P A R M A N O D L
$orange
$cyan    ParmanodL$orange is a computer that runs Parmanode software preconfigured.
    
    Currently this packaged option is available for Pi4/5.

    INSTALLATION:

    An image file (.img) file which contains the operating system will be downloaded
    on this computer, then configured with the help of a Docker container
    running a portable Linux OS, and then flashd to a microSD card (have it ready, 
    minimum 16GB, best 64GB+), for use in the Raspberry Pi computer. 

    Alternatively, you can opt to just download the image file and flash the image
    yourself to the microSD card.

    You will be able to connect to the Pi via a program call SSH, which is a window 
    into the device's terminal screen. There'll be an icon for that on the desktop on
    this computer.

    You can also hook up a moniter/mouse/keyboard to the Pi and use it as a full 
    desktop computer.

    Proceed with installation? 

$green                y)$orange        Create the image file on this computer

$green                d)$orange        I'll just download the ready made one, thanks

$red                n)$orange        Get me out of here

########################################################################################
"
choose "xpmq" ; read choice ; clear
case $choice in
m) return 0 ;;
p|P) return 0 ;;
n|N|no|NO) return 1 ;; 
y|Y|Yes|YES|yes) break ;;
d) download_ParmanodL_image ; return 1 ;;
q|Q|Quit|QUIT) exit 0 ;;
*) invalid ;;
esac
done

please_wait

if ! which docker >/dev/null ; then install_docker || return 1 ; fi 
ParmanodL_Installer install
}
