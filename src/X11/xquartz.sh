function install_xquartz {

if [[ $OS != Mac ]] ; then return 1 ; fi

cd $tmp && curl -LO https://github.com/XQuartz/XQuartz/releases/download/XQuartz-2.8.5/XQuartz-2.8.5.pkg || {
    announce "Something went wrong. Aborting." 
    return 1
    }

if [[ $(shasum -a 256 $tmp/XQuartz-2.8.5.pkg |  awk '{print $1}') != "e89538a134738dfa71d5b80f8e4658cb812e0803115a760629380b851b608782" ]] ; then 
    announce "Something went wrong. Aborting." 
    return 1
fi

sudo installer -pkg XQuartz.pkg -target / \
  && installed_conf_add "xquartz-end" \
  && success "XQuartz has been installed"

}

function start_xquartz { open /Applications/Utilities/Xquartz.app ; }
function stop_xquartz  { pkill -15 Xquartz ; }

function uninstall_xquartz {
    stop_xquartz
    sudo rm -rf /Applications/Utilities/XQuartz.app >$dn 2>&1
    sudo rm -rf /opt/X11 >$dn 2>&1
    sudo rm -rf /private/etc/X11 >$dn 2>&1
    sudo rm -rf /usr/X11 >$dn 2>&1
    sudo rm -rf /usr/X11R6 >$dn 2>&1
    sudo rm -rf /usr/lib/X11 >$dn 2>&1
    sudo rm -rf /Library/Fonts/X11 >$dn 2>&1
    sudo rm -rf ~/.Xauthority ~/.xinitrc ~/.xserverrc >$dn 2>&1
    installed_conf_remove "xquartz"
    success "XQuartz has been removed"
}

