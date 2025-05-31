function uninstall_trezor {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Trezor 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n) return 1 ;; y) break ;;
esac
done

set_terminal

cd $hp ; sudo rm -rf $hp/trezor

if [[ $OS == Linux ]] ; then
configdir="$HOME/.config/@trezor/suite-desktop"
elif [[ $OS == Mac ]] ; then
sudo rm -rf /Applications/"Trezor Suite"
configdir="$HOME/Library/Application Support/@trezor/suite-desktop"
fi
# && is necessary here as exit status of confirm function affects next command
confirm_config_delete "$configdir" && sudo rm -rf $configdir

installed_conf_remove "trezor"
success "Trezor Suite" "being uninstalled."
}

function confirm_config_delete {

while true ; do
clear
echo -e "
########################################################################################

    Also delete the configuration directory? 
           $cyan 
           $1 
$orange
    Warning - the configuration directory is shared between this installation and
    and other manual installations you may have done in parallel.
$red

                            y)     Delete it
$orange
                            n)     No touching!

########################################################################################
"
choose "x"
read choice
case $choice in
q|Q) exit ;; n|N|NO|no) return 1 ;;
y|Y) return 0 ;;
*) invalid ;;
esac
done

}