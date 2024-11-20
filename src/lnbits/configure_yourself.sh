function configure_yourself {
while true ; do
set_terminal ; echo -e "
########################################################################################

    Please note that Parmanode at this stage does not configure LNbits for you. It 
    will install the program within a Docker container, and provide menu options to
    start and stop the container, but you'll have to modify the .env file yourself.

    It can be found in:
$cyan
        $HOME/parmanode/lnbits/.env
$orange
    Continue with installation?       $green y $orange    or    $red  n $orange

########################################################################################
"
choose xpmq ; read choice ; set_terminal
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
y|Y) return 0 ;; n|N) return 1
;;
*)
invalid ;;
esac
done

}
