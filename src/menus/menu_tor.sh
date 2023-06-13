function menu_tor {
while true ; do
set_terminal ; echo "
########################################################################################

                              Tor options for Bitcoin


     1)    Allow Tor connections and clearnet connections
                 - Helps you and the network overall

     2)    Force Tor only connections
                 - Extra private but only helps the Tor network of nodes
    
     3)    Force Tor only OUTWARD connections
                 - Only helps yourself but most private of all options
                 - You can connect to tor nodes, they can't connect to you

     4)    Make Bitcoin public (Remove Tor usage and stick to clearnet)
                 - Generally faster and more reliable

########################################################################################
"
choose "xpq" ; read choice
esac Q|q|quit|QUIT|Quit) exit 0 ;; p|P) return 1 ;;
"1")
    bitcoin_tor "torandclearnet" ;;
"2")
    bitcoin_tor "toronly" ;;
"3")
    true ;;
"4")
    true ;;
*)
    invalid ;;
esac
done

}

function bitcoin_tor_method1 {

if ! which tor >/dev/null 2>&1 ; then install_tor ; fi

if [[ ! -f /etc/tor/torrc ]] ; then
set_terminal ; echo "
########################################################################################
    /etc/tor/torrc file does not exist. You may have a non-standard Tor installation.
    Parmanode won't be able to automate this process for you. Aborting.
########################################################################################
"
enter_continue ; return 1 ;
fi

usermod -a -G tor $USER 

if sudo grep -q "ControlPort 9051" /etc/tor/torrc | grep -v '^#' ; then true ; else
    echo "ControlPort 9051" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep -q "CookieAuthentication 1" /etc/tor/torrc | grep -v '^#' ; then true ; else
    echo "CookieAuthentication 1" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep -q "CookieAuthFileGroupReadable 1" /etc/tor/torrc | grep -v '^#' ; then true ; else
    echo "CookieAuthFileGroupReadable 1" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep -q "DataDirectoryGroupReadable 1" /etc/tor/torrc | grep -v '^#' ; then true ; else
    echo "DataDirectoryGroupReadable 1" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if ! grep -q "listen=1" /$HOME/.bitcoin/bitcoin.conf ; then
    echo "listen=1" | tee -a $HOME/.bitcoin/bitcoin.conf
    fi

}


function bitcoin_tor {

if ! which tor >/dev/null 2>&1 ; then install_tor ; fi

if [[ ! -f /etc/tor/torrc ]] ; then
set_terminal ; echo "
########################################################################################
    /etc/tor/torrc file does not exist. You may have a non-standard Tor installation.
    Parmanode won't be able to automate this process for you. Aborting.
########################################################################################
"
enter_continue ; return 1 ;
fi

if ! grep -q "listen=1" /$HOME/.bitcoin/bitcoin.conf ; then
    echo "listen=1" | tee -a $HOME/.bitcoin/bitcoin.conf
    fi

if sudo grep -q "HiddenServiceDir /var/lib/tor/bitcoin-service/" | grep -v "^#" ; then true ; else
    echo "HiddenServiceDir /var/lib/tor/bitcoin-service/" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if sudo grep -q "HiddenServicePort 8333 127.0.0.1:8333" | grep -v "^#" ; then true ; else
    echo "HiddenServicePort 8333 127.0.0.1:8333" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
    fi

if [[ $OS == "Linux" ]] ; then
    sudo systemctl restart tor
    sudo systemctl restart bitcoind.service
    fi

if [[ $OS == "Mac" ]] ; then
    stop_bitcoind
    run_bitcoind

}