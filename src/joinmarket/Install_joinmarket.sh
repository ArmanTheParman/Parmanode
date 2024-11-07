function install_joinmarket {

    set_terminal

    grep -q "bitcoin-end" < $ic || { 
        announce "Please install Bitcoin first. Aborting." && return 1 
        }
    
    joinmarket_preamble

    if ! grep -q "parmabox-end" $ic  && [[ $OS == Mac ]] ; then

        yesorno "Parmanode needs to install Parmabox before installing
    JoinMarket. OK?" || { echo "Aborting..." ; sleep 2 ; return 1 ; }     
        install_parmabox silent
    fi
    if [[ $OS == Mac ]] && ! docker exec parmabox cat bitcoin-installed 2>/dev/null ; then
        install_bitcoin_docker silent parmabox joinmarket || return 1
        docker cp $bc parmabox:/home/parman/.bitcoin/bitcoin.conf >$dn 2>&1
        docker exec -u root parmabox /bin/bash -c "chown -R parman:parman /home/parman/.bitcoin/"
        docker exec parmabox /bin/bash -c "echo 'rpcconnect=host.docker.internal' | tee -a /home/parman/.bitcoin/bitcoin.conf" >$dn 2>&1
        debug "check bitcoin conf fixed"
    fi

    install_tmux ; if ! which tmux >$dn 2>&1 ; then announce "Need tmux to continue. Couldn't install. Aborting." && return 1 ; fi
    
    if [[ $OS == Linux ]] ; then
        enable_tor_general || { announce "Something went wrong with tor. Aborting." ; return 1 ; }
        if ! grep -q "HiddenServiceDir /var/lib/tor/joinmarket-service/" < $macprefix/etc/tor/torrc ; then
            echo "HiddenServiceDir /var/lib/tor/joinmarket-service/" | sudo tee -a $macprefix/etc/tor/torrc >$dn 2>&1
        fi
        if ! grep -q "HiddenServicePort 5222 127.0.0.1:5222" < $macprefix/etc/tor/torrc ; then
            echo "HiddenServicePort 5222 127.0.0.1:5222" | sudo tee -a $macprefix/etc/tor/torrc 
        fi
    fi

    make_joinmarket_wallet || { enter_continue "aborting" ; return 1 ; }

    mkdir -p $HOME/.joinmarket >$dn 2>&1 && installed_conf_add "joinmarket-start"

    clone_joinmarket || { enter_continue "aborting" ; return 1 ; }

    build_joinmarket || { enter_continue "aborting" ; return 1 ; }

    run_joinmarket_docker || { enter_continue "aborting" ; return 1 ; }

    if [[ $OS == Linux ]] ; then 
        install_bitcoin_docker silent joinmarket || return 1
        docker cp $bc joinmarket:/root/.bitcoin/bitcoin.conf >$dn 2>&1
    fi

    counter=0
    while [[ $counter -lt 7 ]] ; do
        docker exec joinmarket ps >$dn 2>&1 && break
        sleep 1
        counter=$((counter + 1))
    done

    run_wallet_tool_joinmarket install || { enter_continue "aborting" ; return 1 ; }

    modify_joinmarket_cfg || { enter_continue "aborting" ; return 1 ; }

    parmashell_4_jm

    installed_conf_add "joinmarket-end"

    success "JoinMarket has been installed"

}


function make_joinmarket_wallet {

    if ! grep -q "deprecatedrpc=create_bdb" < $bc ; then

        echo "deprecatedrpc=create_bdb" | sudo tee -a $bc >$dn 2>&1
        clear 
        dontrestart="false"

    else
        dontrestart="true" 
    fi

    isbitcoinrunning

    if [[ $bitcoinrunning == "false" ]] ; then
        start_bitcoin
    else
        if [[ $dontrestart == "false" ]] ; then restart_bitcoin  ; fi
    fi

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

    while true ; do
        if [[ $OS == Mac ]] ; then
            docker exec parmabox /bin/bash -c 'bitcoin-cli -named createwallet wallet_name=jm_wallet descriptors=false 2>&1 | grep -q "exists"' && break
            docker exec parmabox /bin/bash -c 'bitcoin-cli -named createwallet wallet_name=jm_wallet descriptors=false' && enter_continue && break
        elif [[ $OS == Linux ]] ; then 
            bitcoin-cli -named createwallet wallet_name=jm_wallet descriptors=false 2>&1 | grep -q "exists" && break
            bitcoin-cli -named createwallet wallet_name=jm_wallet descriptors=false && enter_continue && break
        fi
        echo -e "$red
        Sometimes waiting for bitcoin to laod up is needed.
        Trying again every 10 seconds...$orange
        (q to quit)
        "
        read -sn1 -t 10 input #-s silent printing, -n1 one character, -t timeout

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

    if [[ $1 == install ]] ; then
    docker exec joinmarket bash -c '/jm/clientserver/scripts/wallet-tool.py' >$dn 2>&1
    else
    docker exec joinmarket bash -c '/jm/clientserver/scripts/wallet-tool.py' #do not exit on failure.
    fi

    return 0
}

function modify_joinmarket_cfg {
    jmfile="/root/.joinmarket/joinmarket.cfg"
    source $bc
#    enter_continue "rpcuser: $rpcuser, rpcpassword: $rpcpassword"
    docker exec joinmarket bash -c "sed -i '/rpc_cookie_file =/d' $jmfile"
    docker exec joinmarket bash -c "sed -i '/rpc_wallet_file =/c\\rpc_wallet_file = jm_wallet' $jmfile"
    docker exec joinmarket bash -c "sed -i '/rpc_user =/c\\rpc_user = $rpcuser' $jmfile"
    docker exec joinmarket bash -c "sed -i '/rpc_password =/c\\rpc_password = $rpcpassword' $jmfile"
    docker exec joinmarket bash -c "sed -i '/onion_serving_port =/c\\onion_serving_port = 8077' $jmfile"

    if [[ $OS == Mac ]] ; then
    docker exec joinmarket bash -c "sed -i '/rpc_host =/c\\rpc_host = host.docker.internal' $jmfile"
    fi

    return 0
}


function build_joinmarket {

    unset success_build #do not use 'success' as a variable, it deletes the success function
    rm $hp/joinmarket/Dockerfile >$dn 2>&1

    if [[ $OS == Linux ]] ; then
        cp $pn/src/joinmarket/Dockerfile $hp/joinmarket/Dockerfile >$dn 2>&1
    elif [[ $OS == Mac ]] ; then
        cp $pn/src/joinmarket/Dockerfile_mac $hp/joinmarket/Dockerfile >$dn 2>&1
        cp $pn/src/joinmarket/Dockerfile_torrc $hp/joinmarket/ >$dn 2>&1
        cp $pn/src/joinmarket/Dockerfile_torsocks.conf $hp/joinmarket/ >$dn 2>&1
    fi

    cd $hp/joinmarket
    docker build -t joinmarket . && success_build="true"
    enter_continue

    if [[ $success_build == "true" ]] ; then return 0 ; else return 1 ; fi
}

function run_joinmarket_docker {

if [[ $OS == Linux ]] ; then

    docker run -d \
               --name joinmarket \
               -v $HOME/.joinmarket:/root/.joinmarket \
               -v /run/tor:/run/tor \
               -v /var/lib/tor/joinmarket-service:/var/lib/tor/joinmarket-service \
               --network="host" \
               --restart unless-stopped \
               joinmarket
    return 0

elif [[ $OS == Mac ]] ; then

    docker run -d \
               --name joinmarket \
               -v $HOME/.joinmarket:/root/.joinmarket \
               -p 61000:61000 \
               --restart unless-stopped \
               joinmarket
    return 0
fi

    start_socat joinmarket
    internal_docker_socat_jm_mac 

}

function clone_joinmarket {

    cd $hp && git clone --depth 1 https://github.com/JoinMarket-Org/joinmarket-clientserver.git joinmarket \
        || { enter_continue "Something went wrong$green.$orange" && return 1 ; }

    return 0 
}

function parmashell_4_jm {

cat << 'EOF' | tee $tmp/b1 >$dn 2>&1
export LS_OPTIONS='--color=auto'
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
EOF

cat $tmp/b1 $pn/src/ParmaShell/parmashell_functions > $tmp/b2

echo "a" | tee -a $tmp/b2 >$dn 2>&1

docker cp $tmp/b2 joinmarket:/root/.bashrc >$dn 2>&1
}

function joinmarket_preamble {

if [[ $OS == Mac ]] ; then
mac_text="$red $blinkon 
    I M P O R T A N T . . .
$blinkoff $orange
    Sometimes during this installation, Parmanode will require your regular system 
    password, and sometimes it will require the password for the parman user inside 
    the ParmaBox container - this password is set to '${cyan}parmanode$orange' as the default. "
fi

set_terminal ; echo -ne "
########################################################################################

    You are about to install$cyan ParmaJoin$orange, which is software that manages
    the JoinMarket protocol - a decentralized marketplace for Bitcoin users 
    to coordinate CoinJoin transactions. 

    It will run on your computer inside a Docker container, alongside Bitcoin Core or
    Bitcoin Knots on the system.
    $mac_text

########################################################################################
"
enter_continue

}