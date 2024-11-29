function menu_x11 {
   
if ! grep -q "x11-end" $ic ; then menu_main ; fi

while true ; do 

if [[ $OS == "Linux" ]] ; then
    local file="/etc/ssh/sshd_config"
elif [[ $OS == "Mac" ]] ; then
    local file="/private/etc/ssh/sshd_config"
fi
set_terminal ; echo -e "
########################################################################################
                 $cyan              X11 Menu            $orange                   
########################################################################################
"
if [[ $OS == "Mac" ]] && grep -q "xquartz-end" $ic ; then
echo -en " $green
                       start)$orange        Start XQuartz
$red                       
                       stop)$orange         Start XQuartz
"
else echo "" ; fi 
echo -en "$cyan
                       conf)$orange         View/edit sshd_config (confv for vim) 
$cyan
                       rs)$orange           Restart sshd (the ssh daemon)

    To use X11, access this computer like this...
$bright_blue
    ssh -X $whoami@$IP
$orange

########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) menu_use ;; 
start)
start_xquartz
;;
stop)
stop_xquartz

conf)
sudo nano $file
;;
confv)
sudo vim $file
;;
rs)
restart_sshd
set_terminal ; echo "SSHD restarted" ; sleep 1
;;
*)
invalid
;;
esac
done
} 