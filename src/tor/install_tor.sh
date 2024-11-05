function install_tor {

if which tor >/dev/null 2>&1 ; then installed_config_add "tor-end" ; export tor_already_installed=true ; return 0 ; fi

if [[ $1 != silent ]] ; then

    set_terminal ; echo -e "
########################################################################################
$cyan
                                   Install Tor
$orange    
    Parmanode will install Tor daemon (not the browser). It runs in the background 
    allowing you to access the Tor network.

########################################################################################    
"
    choose "epq" ; read choice

    case $choice in Q|q|Quit|QUIT) exit 0 ;; p|P) return 1 ;; *) true ;; esac
fi

set_terminal

if [[ $OS == "Linux" ]] ; then  sudo apt-get install tor -y ; fi

if [[ $OS == "Mac" ]] ; then

    brew_check || return 1

    local varlibtor="$macprefix/var/lib/tor" >$dn 2>&1
    local torrc="$macprefix/etc/tor/torrc" >$dn 2>&1
    if [[ ! -e $varlibtor ]] ; then mkdir -p $varlibtor ; fi
    if [[ ! -e $torrc ]] ; then sudo touch $torrc ; fi

    brew install tor && brew services start tor 
fi

if [[ $1 == silent ]] ; then

    set_terminal
    enter_continue "
########################################################################################
$cyan
    Tor $orange should now be installed and running in the background. It also starts up
    again when your computer restarts.

    Linux users can stop Tor from the terminal with :
$yellow
            sudo systemctl stop tor
$orange
    Mac users can stop Tor from the terminal with :
$yellow
            brew services stop tor
$orange
########################################################################################
"
fi

if which tor >/dev/null ; then 
    installed_conf_add "tor-end"
    return 0 
else 
    installed_conf_remove "tor-end"
    installed_conf_remove "tor-start"
    return 1 
fi

installed_config_add "tor-end"

if [[ $1 == silent ]] ; then
    success "Tor" "being installed"
fi
return 0
}
