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

    You will be able to connect to it via a program call SSH, which is a window into
    the ParmanodL's terminal screen. There'll be an icon for that on the desktop, but
    you can also access it from within this computer's Parmanode menu.

    You can also hook up a moniter/mouse/keyboard to the Pi and use it as a full 
    desktop computer.

    Proceed with installation?   $cyan  y   or   n$orange    then <enter>

########################################################################################
"
read choice
case $choice in
n|N|no|NO) return 1 ;; 
y|Y|Yes|YES|yes) break ;;
*) invalid
esac
done

if ! which docker >/dev/null ; then install_docker || return 1 ; fi 

debug "pre get parmanodl"
get_parmanodl


}