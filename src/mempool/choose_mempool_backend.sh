function choose_mempool_backend {
#decided this choice was unnecessary
return 0

unset mbackend
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
    To what service would you like Mempool to connect to for its data?
$orange
$green
                    1)      Bitcoin Core (on this computer - recommended) $orange

                    2)      Electrs (on this computer)

                    3)      Fulcrum (on this computer)
    
                    4)      Bitcoin Core (another computer)

                    5)      Any type of Electrum Server (another computer)
$orange
########################################################################################
"
choose xpmq ; read mbackend ; set_terminal
case $mbackend in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
1|2|3|4|5)
break
;;
*)
invalid
;;
esac
done
}