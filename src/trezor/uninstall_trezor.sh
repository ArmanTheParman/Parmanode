function uninstall_trezor {
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Trezor 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "x" 
read choice
set_terminal

if [[ $choice == "y" || $choice == "Y" ]] ; then true
    else 
    return 1
    fi

set_terminal

cd $hp ; rm -rf $hp/trezor

if [[ $OS == Linux ]] ; then
configdir="$HOME/.config/@trezor/suite-desktop"
elif [[ $OS == Mac ]] ; then
rm -rf /Applications/"Trezor Suite"
configdir="/Users/ArmanK/Library/Application Support/@trezor/suite-desktop"
fi
# && is necessary here as exit status of confirm function affects next command
confirm_config_delete "$hp/trezor" && rm -rf $configdir

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