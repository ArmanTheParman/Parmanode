function menu_yg {

while true ; do
set_terminal ; echo -e "
########################################################################################

                                   YEILD GENERATOR                         $cyan
                             Be a coinjoin market maker                   $orange

########################################################################################

$green
                    start)$orange    Start Yield Generator 
$red
                    stop)$orange     Start Yield Generator 
$yellow
                    c)$orange        Configure Yeild Generator Settings...
$cyan
                    log)$orange      Yield Generator log




########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) return 0 ;;

start)
docker exec -d joinmarket bash -c "./yg-privacyenhanced.py $wallet"


;;
log)
    check_wallet_loaded || continue
    yield_generator_log || return 1
    ;;
c)
    configure_yg 
    ;;
*)
    invalid
    ;;
esac
done
}

