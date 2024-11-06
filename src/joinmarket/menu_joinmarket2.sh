function menu_joinmarket2 {
while true ; do
set_terminal ; echo -en "
########################################################################################$cyan

                                P A R M A J O I N
                                      Menu 2$orange

########################################################################################

    Active wallet is:    $red$wallet$orange


$cyan
                  vc)$orange          Remove all config comments and make pretty
$cyan
                  man)$orange         Manually access container and mess around
$cyan
                  sp)$orange          Spending (info) 
$cyan 
                  jml)$orange         Inspect joinmarket docker container logs
$cyan
                  obl)$orange         Order book log (obln for nano)

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) return 0 ;; 

vc)
cfg="$HOME/.joinmarket/joinmarket.cfg" 
sed '/^#/d' $cfg | sed '/^$/d' | sed '/\[/a\ ' | sed '/\[/i\ ' | tee $tmp/cfg >$dn 2>&1
sudo mv $tmp/cfg $cfg
enter_continue "file modified"
;;
man)
clear
enter_continue "Type exit and <enter> to return from container back to Parmanode"
clear
docker exec -it joinmarket bash 
;;

sp)
spending_info_jm
;;

jml)
announce "Hit q to exit this. Use vim style controls to move about."
docker logs joinmarket | less
;;
obl)
announce "Hit q to exit this. Use vim style controls to move about.

          \r    Note that connection advice in this output (localhost:62601)
          \r    will not work because it's running in a Docker container.
          \r    Just follow the connection information in the 
          \r    Parmanode menu.
"
less $oblogfile
;;
obln)
announce "Hit control x to exit this. Use vim style controls to move about.

          \r    Note that connection advice in this output (localhost:62601)
          \r    will not work because it's running in a Docker container.
          \r    Just follow the connection information in the 
          \r    Parmanode menu.
"
nano $oblogfile
;;

*)
invalid
;;
esac
done
}
