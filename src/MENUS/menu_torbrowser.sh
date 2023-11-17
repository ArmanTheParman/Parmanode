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
if [[ $OS == "Linux" ]] ; then 
$HOME/.local/share/applications/start-tor-browser.desktop
fi
;;

*)
invalid ;;
esac  

done
return 0
}