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

confirm_config_delete "$hp/trezor" && rm -rf $HOME/.config/@trezor/suite-desktop

if [[ $OS == Mac ]] ; then
configdir="/Users/ArmanK/Library/Application Support/@trezor/suite-desktop"
rm -rf /Applications/"Trezor Suite"
confirm_config_delete "$configdir" && rm -rf /Users/ArmanK/Library/Application Support/@trezor/suite-desktop
fi

installed_conf_remove "trezor"
success "Trezor Suite" "being uninstalled."

}

function confirm_config_delete {

while true ; do
clear
echo -e "
########################################################################################

    Also delete the configuration directory? 
            
           $1 

    Warning - the configuration directory is shared between this installation and
    and other manual installations you may have done in parallel.
$red

                            y)     Delete it
$orange
                            n)     No touching

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