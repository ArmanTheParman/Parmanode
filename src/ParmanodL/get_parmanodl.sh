function get_parmanodl {
while true ; do
set_terminal ; echo -e "
########################################################################################
$green
                                 P A R M A N O D L
$orange
$cyan    ParmanodL$orange is a computer that runs Parmanode OS. 
    
$red    Parmanode$orange OS is a Linux operating system, modified with Parmanode software 
    preconfigured.

    It runs on a Raspberry Pi 4.

    A large .img file (the operating system) will be downloaded, configured, and 
    flashd to microSD card (have it ready, minimum 16GB), for use in the Pi 4.

    You will be able to connect to the Pi via a program call SSH, which is a window 
    into the device's terminal screen. There'll be an icon for that on the desktop on
    this computer.

    You can also hook up a moniter/mouse/keyboard to the Pi and use it as a full 
    desktop computer.

    Proceed with installation?   $cyan  y   or   n$orange    then <enter>

########################################################################################
"
choose "xpmq" ; read choice ; clear
case $choice in
m) return 0 ;;
p|P) return 0 ;;
n|N|no|NO) return 1 ;; 
y|Y|Yes|YES|yes) break ;;
q|Q|Quit|QUIT) exit 0 ;;
*) invalid
esac
done

if ! which docker >/dev/null ; then install_docker || return 1 ; fi 
debug "pre isntaller"
parmanodl_installer install
debug "post installer"
}