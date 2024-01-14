function install_tor {

set_terminal ; echo -e "
########################################################################################
$cyan
                                   Install Tor
$orange    
    Parmanode will install Tor daemon (not browser). It runs in the background allowing
    you to access the Tor network.

########################################################################################    
"
choose "epq" ; read choice

if which tor >/dev/null 2>&1 ; then installed_config_add "tor-end" ; return 0 ; fi

case $choice in Q|q|Quit|QUIT) exit 0 ;; p|P) return 1 ;; *) true ;; esac

set_terminal

if [[ $OS == "Linux" ]] ; then { sudo apt-get install tor -y ; } || { errormessage && return 1 ; } 
fi

if [[ $OS == "Mac" ]] ; then
brew_check Tor || return 1
{ brew install tor && brew services start tor ; } || { log "tor" "failed at tor install && start tor" ; errormessage ; return 1 ; }
fi

set_terminal ; echo -e "
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
installed_config_add "tor-end"
success "Tor" "being installed"
return 0
}
