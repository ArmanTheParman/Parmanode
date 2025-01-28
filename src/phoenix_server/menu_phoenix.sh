function menu_phoenix {
while true ; do 
if ! grep -q "phoenix-end" $ic ; then return 0 ; fi

set_terminal ; echo -e "
########################################################################################$cyan
                              Phoenix Server Menu $orange
########################################################################################


$cyan            start) $orange          Start Phoenix Server Daemon

$cyan            stop)  $orange          Start Phoenix Server Daemon

$cyan            info)  $orange          Information 

$cyan            uninstall) $orange      Uninstall Phoenix

########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit ;; p|P) menu_use ;; 

start|Start|START|S|s)
start_phoenix
;;
stop)
stop_phoenix
;;
info)
announce "Phoenix is a daemon (background process) running inside a Tmux container.
    Start it an stop it from the this Parmanode menu.

    To interactive with it, you need to use the command line. Parmanode has not
    been designed to do this for you like most other Apps it installs. Maybe one day."
;;
uninstall)
uninstall_phoenix
;;
*)
invalid
;;
esac
done

} 