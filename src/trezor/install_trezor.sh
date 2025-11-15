function install_trezor {  

while true ; do
    export version="25.10.2"
    Announce "Parmanode will install Trezor Suite version $version.
        If you accept this version, hit$cyan <enter>$orange, otherwise, type
        in the version number and hit $cyan<enter>$orange; it'll probably work,
        but no guarantees, and no big deal, you can come back and try the default version."
    jump $enter_cont
    case $enter_cont in "") break ;; *) yesorno "Use this version? v$enter_cont" || continue ; version=$enter_cont ;; esac
done
set_terminal

if [[ $OS == "Linux" ]] ; then
export configdir="$HOME/.config/@trezor/suite-desktop"
elif [[ $OS == "Mac" ]] ; then
export configdir="$HOME/Library/Application Support/@trezor/suite-desktop"
fi

if [[ -d $configdir ]] ; then
#if user chooses "d" for delete, return 0, and && exectued.
confirm_remove_previous_config_trezor && rm -rf $configdir
fi

clear

trezorDir=$HOME/parmanode/trezor
mkdir $trezorDir 
cd $trezorDir
installed_conf_add "trezor-start"

if [[ $chip == "arm64" && $OS == "Mac" ]] ; then
curl -LO    https://github.com/trezor/trezor-suite/releases/download/v$version/Trezor-Suite-$version-mac-arm64.dmg
curl -LO    https://github.com/trezor/trezor-suite/releases/download/v$version/Trezor-Suite-$version-mac-arm64.dmg.asc
verify_trezor || return 1
hdiutil attach *.dmg ; cd /Volumes/Trezor* ; sudo rm -rf /Applications/"Trezor Suite" ; cp -R *app /Applications
cd $trezorDir
hdiutil detach /Volumes/"Trezor"* 
sudo rm -rf *.dmg
fi

if [[ $chip == "x86_64" && $OS == "Mac" ]] ; then
curl -LO https://github.com/trezor/trezor-suite/releases/download/v$version/Trezor-Suite-$version-mac-x64.dmg
curl -LO https://github.com/trezor/trezor-suite/releases/download/v$version/Trezor-Suite-$version-mac-x64.dmg.asc
verify_trezor || return 1
hdiutil attach *.dmg ; cd /Volumes/Trezor* ; sudo rm -rf /Applications/"Trezor Suite" ; cp -R *app /Applications
cd $trezorDir
hdiutil detach /Volumes/"Trezor"* 
sudo rm -rf *.dmg
fi

if [[ $chip == "x86_64" && $OS == "Linux" ]] ; then
rm *AppImage 2>$dn
curl -LO https://github.com/trezor/trezor-suite/releases/download/v$version/Trezor-Suite-$version-linux-x86_64.AppImage
curl -LO https://github.com/trezor/trezor-suite/releases/download/v$version/Trezor-Suite-$version-linux-x86_64.AppImage.asc
verify_trezor || return 1
sudo chmod +x ./*AppImage
    if ! grep -q udev-end $ic ; then
    echo "installing udev rules..."
    udev
    fi
fi

if [[ $computer_type == "Pi" && $chip == "aarch64" ]] ; then
rm *AppImage 2>$dn
curl -LO https://github.com/trezor/trezor-suite/releases/download/v$version/Trezor-Suite-$version-linux-arm64.AppImage 
curl -LO https://github.com/trezor/trezor-suite/releases/download/v$version/Trezor-Suite-$version-linux-arm64.AppImage.asc
verify_trezor || return 1
sudo chmod +x ./*AppImage
    if ! grep -q udev-end $ic ; then
    echo "installing udev rules..."
    udev
    fi
fi

installed_conf_add "trezor-end"
success "Trezor Suite" "being installed."
}



function confirm_remove_previous_config_trezor {
while true ; do
clear
echo -e "
########################################################################################

    Parmanode has detected the presence of a Trezor configuration directory at
$cyan
        $configdir
$orange
    You have choices:
$red
                                d)      Delete it
$orange
                                n)      No touching!

########################################################################################                
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;; d|D) return 0 ;; n|N) return 1 ;; *) invalid ;; esac
done
}
