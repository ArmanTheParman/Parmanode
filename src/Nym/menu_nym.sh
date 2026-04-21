function menu_nym {

#for old installation, no AppImage, and so no menu options.
if  ! test -f $hp/nym/*AppImage ; then
announce "Please use the operating system's menus to find the Nym App and start it.
    (ie use the grphical interface and the mouse)"
fi

while true ; do
set_terminal
echo -e "$orange
########################################################################################$cyan
                                  NYM VPN MENU$orange



$cyan
            start)$orange               Start
$cyan
             stop)$orange               Stop


########################################################################################"
choose xpmq ;  read choice 
jump $choice || { invliad ; continue ; }
case $choice in
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 
m|M) back2main ;;
start) start_nym ;;
stop) stop_nym ;;
esac
done
}

