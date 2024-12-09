function install_joinmarket {

    set_terminal

    grep -q "bitcoin-end" $ic || { 
        announce "Please install Bitcoin first. Aborting." && return 1 
        }
    
    joinmarket_preamble
    
    #Parmabox is needed for Macs becuase Bitcoin on Macs don't have bitcoin-cli
    if [[ $OS == "Mac" ]] ; then
        if ! grep -q "parmabox-end" $ic ; then
            yesorno "Parmanode needs to install Parmabox before installing JoinMarket. OK?" \
            || { echo "Aborting..." ; sleep 2 ; return 1 ; }     
            install_parmabox silent
        fi

        if ! docker ps | grep -q parmabox ; then
        while true ; do
        yesorno "ParmaBox needs to be running. Let Parmanode start it?" && { docker start parmabox ; break ; }
        return 1
        done
        fi
    fi

    isbitcoinrunning
    if [[ $bitcoinrunning == "false" ]] ; then
        announce "Bitcoin needs to be running. Please start it. Aborting."
        return 1
    fi

    if [[ $OS == "Mac" ]] && ! docker exec parmabox cat /home/parman/bitcoin-installed 2>$dn ; then
        install_bitcoin_docker silent parmabox joinmarket || return 1
        docker cp $bc parmabox:/home/parman/.bitcoin/bitcoin.conf >$dn 2>&1
        docker exec -u root parmabox /bin/bash -c "chown -R parman:parman /home/parman/.bitcoin/"
        docker exec -u root parmabox /bin/bash -c "echo 'rpcconnect=host.docker.internal' | tee -a /home/parman/.bitcoin/bitcoin.conf" >$dn 2>&1
    fi

    make_joinmarket_wallet || { enter_continue "aborting" ; return 1 ; }

    mkdir -p $HOME/.joinmarket >$dn 2>&1 && installed_conf_add "joinmarket-start"
    sudo chown -R $USER:$(id -gn) $HOME/.joinmarket >$dn 2>&1

    clone_joinmarket || { announce "Something went wrong. Aborting" ; return 1 ; }
    
    joinmarket_dependencies || return 1

    cd $hp/joinmarket

    echo "y" | ./install.sh || { enter_continue  "Something went wrong. Aborting." ; return 1 ; }

    cd $hp/joinmarket >$dn

    source jmvenv/bin/activate || { announce "Something went wrong with the virtual env. Aborting." ; return 1 ; }

    #matplotlib needed for obwatcher, but it causes errors. downgrading numpy fixes that. This order is necessary.
    pip install matplotlib && pip install 'numpy<2' || { announce "Something went wrong with installing matplotlib. Aborting." ; return 1 ; } 

    run_wallet_tool_joinmarket install || { enter_continue "aborting" ; return 1 ; }

    make_joinmarket_config || { enter_continue "aborting" ; return 1 ; }
    
    deactivate >$dn 2>&1

    installed_conf_add "joinmarket-end"

    success "JoinMarket has been installed"

}


function make_joinmarket_wallet {

    if ! grep -q "deprecatedrpc=create_bdb" $bc ; then

        echo "deprecatedrpc=create_bdb" | sudo tee -a $bc >$dn 2>&1
        clear 
        dontrestart="false"

    else
        dontrestart="true" 
    fi

    isbitcoinrunning

    if [[ $bitcoinrunning == "false" ]] ; then
        announce "Bitcoin needs to be running. Please start it."
        start_bitcoin
    else
        if [[ $dontrestart == "false" ]] ; then announce "Parmanode needs to restart Bitcoin." ; restart_bitcoin  ; fi
    fi
debug "0"
    if [[ $bitcoinrunning != "true" ]] ; then
        echo -e "${red}Waiting for bitcoin to start... (hit q to exit loop)$orange
        "
        sleep 1

        while true ; do
            read -sn1 -t 1 input #-s silent printing, -n1 one character, -t timeout
            if [[ $input == 'q' ]] ; then return 1 ; fi
            isbitcoinrunning
            if [[ $bitcoinrunning == "true" ]] ; then break ; fi
        done
    fi

    set_terminal
    echo -e "${green}Creating joinmarket wallet with Bitcoin Core/Knots...${orange}"
debug "1"
    while true ; do
        #Loop to make sure bitcoin registers rpc call; if the wallet exists, it will break successfully
        
        if [[ $OS == "Mac" ]] ; then
            bcdocker="/home/parman/.bitcoin/bitcoin.conf"
            rpcconnect="rpcconnect=host.docker.internal"
            docker exec -u root parmabox /bin/bash -c "grep -q $rpcconnect $bcdocker || echo "$rpcconnect" | tee -a $bcdocker >$dn"
            docker exec parmabox /bin/bash -c 'bitcoin-cli -named createwallet wallet_name=jm_wallet descriptors=false 2>&1 | grep -q "exists"' >$dn 2>&1 && break
            docker exec parmabox /bin/bash -c 'bitcoin-cli -named createwallet wallet_name=jm_wallet descriptors=false 2>&1 | grep -q "exists"' >$dn 2>&1 && break
            docker exec parmabox /bin/bash -c 'bitcoin-cli -named createwallet wallet_name=jm_wallet descriptors=false 2>&1 | grep -q "exists"' >$dn 2>&1 && break

        elif [[ $OS == "Linux" ]] ; then 
            bitcoin-cli -named createwallet wallet_name=jm_wallet descriptors=false |& grep "exists" && break
            bitcoin-cli -named createwallet wallet_name=jm_wallet descriptors=false |& grep "exists" && break
            bitcoin-cli -named createwallet wallet_name=jm_wallet descriptors=false |& grep "exists" && break
        fi
        
        echo -e "$red
        sometimes waiting for bitcoin to laod up is needed.
        Trying again every 5 seconds...$orange
        (q to quit)
        "
        read -sn1 -t 5 input #-s silent printing, -n1 one character, -t timeout

        if [[ $input == 'q' ]] ; then return 1 
        elif [[ -z $input ]] ; then continue 
        else sleep 2 
        fi

    done
    clear

}

function run_wallet_tool_joinmarket {

    set_terminal
    echo -e "${green}Running Joinmarket wallet tool...${orange}"

    if [[ $1 == "install" ]] ; then
        jmvenv "activate"
        $hp/joinmarket/scripts/wallet-tool.py >$dn 2>&1
        jmvenv "deactivate"
    else
        jmvenv "activate"
        $hp/joinmarket/scripts/wallet-tool.py #do not exit on failure.
        jmvenv "deactivate"
    fi

    return 0
}

function clone_joinmarket {

    cd $hp && git clone https://github.com/JoinMarket-Org/joinmarket-clientserver.git joinmarket || return 1
    cd $hp/joinmarket
    git checkout f4c2b1b86857762e1ca2fa6442bceb347523efda  #version 0.9.11 - tag checkout doesn't work for some reason.
    return 0 
}


function joinmarket_preamble {

if [[ $OS == "Mac" ]] ; then
mac_text="$red $blinkon 
    I M P O R T A N T . . .
$blinkoff $orange
    Sometimes during this installation, Parmanode will require your regular system 
    password, and sometimes it will require the password for the parman user inside 
    the ParmaBox container - this password is set to '${cyan}parmanode$orange' as the default. 
    "
fi

set_terminal ; echo -ne "
########################################################################################

    You are about to install$cyan ParmaJoin$orange, which is software that manages
    the JoinMarket protocol - a decentralized marketplace for Bitcoin users 
    to coordinate CoinJoin transactions. 
    $mac_text
########################################################################################
"
enter_continue ; jump $enter_cont

}

function joinmarket_dependencies {

#INSTALL SOCAT
if ! which socat >$dn 2>&1 ; then
    if [[ $OS == "Mac" ]]   ; then brew_check || return 1 ; brew install socat ; fi
    if [[ $OS == "Linux" ]] ; then sudo apt-get update -y ; sudo apt-get install socat -y ; fi
fi

#JoinMarket requires Python >=3.8, <3.13 installed.

if ! which python3 >$dn 2>&1 ; then install_python3 ; fi

pythonversion=$(python3 --version | grep -oE '[0-9]+\.[0-9]+')
pythonversion_minor=$(echo $pythonversion | cut -d \. -f2)
if [[ $pythonversion_minor -ge 12 ]] || [[ $pythonversion_minor -le 8 ]] ; then
announce "Python needs to be >=v3.8 and <3.12. You have $pythonversion.

    For now, Parmanode will leave this error for you to manage. The easiest solution
    is to uninstall Python3 and install Python3.11 and try installing ParmaJoin
    again. 

    If you're using a Mac, with Homebrew installed, you can type this in the
    terminal, for example...
$cyan
    brew uninstall python@3.12
    brew install python@3.11 $orange

    Aborting."
return 1
fi

if [[ $OS == "Mac" ]] && ! xcode-select -p ; then 
    if yesorno "Need xcode tools installed. Install it? (takes a while)."  ; then
        xcode-select --install || { announce "Something went wrong" ; return 1 ; }
    else
        return 1
    fi
fi

#sudo apt install mesa-utils

}

function install_python3 {

if [[ $OS == "Mac" ]] ; then
brew_check || return 1
brew install python3 || { announce "Couldn't install python3. Aborting." ; return 1 ; }
return 0 
fi

if [[ $OS == "Linux" ]] ; then
sudo apt-get update -y 
sudo apt-get install python3
return 0
fi
}
