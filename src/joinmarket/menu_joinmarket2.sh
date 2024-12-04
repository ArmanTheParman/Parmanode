function menu_joinmarket2 {
if ! grep -q "joinmarket-end" $ic ; then return 0 ; fi
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
                  sp)$orange          Spending (info) 
$cyan
                  obl)$orange         Order book log (obln for nano)

########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) return 0 ;; 

vc)
cfg="$HOME/.joinmarket/joinmarket.cfg" 
sed '/^#/d' $cfg | sed '/^$/d' | sed '/\[/a\ ' | sed '/\[/i\ ' | tee $tmp/cfg >$dn 2>&1
sudo mv $tmp/cfg $cfg
enter_continue "file modified"
;;

sp)
spending_info_jm
;;

obl)
announce "Hit q to exit this. Use 'vim' style controls to move about.

          \r    Note that connection advice in this output (localhost:62601)
          \r    will not work because it's running in a Docker container.
          \r    Just follow the connection information in the 
          \r    Parmanode menu.
"
less -R $oblogfile
;;
obln)
announce "Hit control x to exit nano text editor.

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
