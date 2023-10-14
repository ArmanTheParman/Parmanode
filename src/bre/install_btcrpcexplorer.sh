# install_btcexplorer
# confugure_btcrpcexplorer
# btcrpcexplorer_questions
# make_btcrpcexplorer_config
# make_btcrpcexplorer_service


function install_btcrpcexplorer {
set_terminal
if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi
if [[ $chip != "x86_64" ]] ; then 
set_terminal ; echo -e "
########################################################################################

       For$cyan x86_64$orange machines only. Your machine is $chip.
       Please send a bug report if something is wrong.

########################################################################################
" ; enter_continue
return 1
fi

if ! cat $HOME/.parmanode/installed.conf | grep fulcrum-end >/dev/null ; then 
    set_terminal ; echo -e "
########################################################################################

    Be Warned, BTC RPC Explorer won't work unless you installed Bitcoin$cyan and either$orange 
    Fulcrum server or electrs server first. You could, instead modify the 
    configusrtion file and point it to a Fulcrum or Electrum Server on this or 
    another machine.

    Proceed anyway?   y  or  n

########################################################################################
"
    read choice

    if [[ $choice != "y" ]] ; then return 1 ; fi
fi

install_nodejs || return 1

installed_config_add "btcrpcexplorer-start" 

cd $HOME/parmanode
git clone --depth 1 https://github.com/janoside/btc-rpc-explorer.git
chuck "clone done"
cd btc-rpc-explorer
sudo npm install -g btc-rpc-explorer
chuck "npm install done - see which btc-rpc-explorer"
installed_config_add "btcrpcexplorer-end"

configure_btcrpcexplorer

btcrpcexplorer_questions

make_btcrpcexplorer_config

make_btcrpcexplorer_service 
chuck "Now see if there is a file in /usr/bin - type ls /usr/bin/btc*"

success "BTC RPC Explorer" "being installed."
return 0
}

function configure_btcrpcexplorer {
#for older versions of Parmanode...
if cat $HOME/.parmanode/parmanode.conf | grep -q "btc_authentication" ; then return 0 ; else
    if cat $HOME/.bitcoin/bitcoin.conf | grep -q "rpcuser=" ; then export btc_authentication="user/pass" ; else export btc_authentication="cookie" ; fi
    parmanode_conf_remove "btc_authentication"
    parmanode_conf_add "btc_authentication=$btc_authentication"
fi
}

#delete this, copied to docker
function btcrpcexplorer_questions {

if ! which dmidecode ; then sudo apt-get install dmidecode ; fi

biosDate=$(sudo dmidecode -t bios | grep Date | cut -d / -f 3)

if [[ -n "$biosDate" && "$biosDate" =~ ^[0-9]{4}$ && $biosDate -lt 2017 ]] ; then 
export fast_computer=false
elif [[ -n "$biosDate" && "$biosDate" =~ ^[0-9]{4}$ && $biosDate -ge 2017 ]] ; then
export fast_computer=true
else

set_terminal
echo -e "
########################################################################################

    Parmanode can configure BTC RPC Explorer to give you a better experience during
    the installation.

    Is your computer probably older than 6 years? $cyan   y  or  n $orange

########################################################################################
"
choose "x"
read choice

if [[ $choice == "y" ]] ; then export fast_computer="yes" ; else fast_computer="false" ; fi
fi
}

