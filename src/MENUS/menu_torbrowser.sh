function menu_torbrowser {
while true ; do
set_terminal ; echo -e "
########################################################################################

                     $cyan              TOR Browser    $orange


                       start)          Start Tor Browser 

######################################################################################## 
"
choose "xpmq" ; read choice
case $choice in 
m|M) back2main ;;
Q|q|QUIT|Quit|quit) 
    exit 0 ;; 

p|P) menu_use ;; 

start|START) 
if [[ $computer_type == LinuxPC ]] ; then 
$hp/tor-browser/s*
debug "look"
return 0
fi

if [[ $OS == Mac ]] ; then
open /Applications/"Tor Browser.app"
return 0
fi
;;

*)
invalid ;;
esac  

done
return 0
}
