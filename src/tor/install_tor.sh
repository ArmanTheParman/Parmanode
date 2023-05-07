function install_tor {

set_terminal ; echo "
########################################################################################

                                   Install Tor
    
    Parmanode will install Tor daemon (not browser). It runs in the background allowing
    you to access the Tor network.

########################################################################################    
"
choose "epq" ; read choice

if which tor >/dev/null 2>&1 ; then installed_config_add "tor-end" ; return 0 ; fi

case $choice in Q|q|Quit|QUIT) exit 0 ;; p|P) return 1 ;; *) true ;; esac

set_terminal

if [[ $OS == "Linux" ]] ; then sudo apt install tor -y ; enter_continue || errormessage && return 1 ; fi
if [[ $OS == "Mac" ]] ; then
    while ! command -v brew ; do
        set_terminal ; echo "Homebrew needs to be installed. Do that now (y) (n)?"
        read choice
        case $choice in y|Y) install_homebrew ;; n|N) break ;; esac
    done

    brew install tor && brew services start tor || errormessage && return 1
fi

set_terminal ; echo "
########################################################################################

    Tor should now be installed and running in the background. It also starts up
    again when your computer restarts.

    Linux users can stop Tor from the terminal with :

            sudo systemctl stop tor

    Mac users can stop Tor from the terminal with :

            brew services stop tor

########################################################################################
"
installed_config_add "tor-end"
enter_continue
return 0
}
