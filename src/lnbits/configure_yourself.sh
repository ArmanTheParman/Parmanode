function configure_yourself {
while true ; do
set_terminal ; echo "
########################################################################################

    Please note that Parmanode at this stage does not configure LNbits for you. It 
    will install the program within a Docker container, and provide menu options to
    start and stop the container, but you'll have to modify the .env file yourself.

    It can be found in:

        $HOME/parmanode/lnbits/.env

    Continue with installation?        y     or      n

########################################################################################
"
read choice
case $choice in 
y|Y) return 0
;;
n|N) return 1
;;
*)
invalid ;;
esac
done

}
