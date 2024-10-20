function install_joinmarket {

    set_terminal

    if [[ $(uname) == Darwin ]] ; then no_mac ; return 1 ; fi

    grep -q "bitcoin-end" < $ic || { 
        announce "Please install Bitcoin first. Aborting." && return 1 
        }

    make_joinmarket_wallet || return 1

    mkdir -p $HOME/.joinmarket >$dn 2>&1 && installed_conf_add "joinmarket-start"

    clone_joinmarket || return 1 #clone must be before build

    build_joinmarket || return 1

    run_joinmarket_docker || return 1

    run_wallet_tool_joinmarket || return 1

    modify_joinmarket_cfg || return 1

    installed_conf_add "joinmarket-end"
    success "JoinMarket has been installed"

}


function make_joinmarket_wallet {

    if ! grep -q "deprecatedrpc=create_bdb" < $bc ; then

        echo "deprecatedrpc=create_bdb" | sudo tee -a $bc >$dn 2>&1
        clear && echo -e "${green}added 'deprecatedrpc=create_bdb' to bitcoin.conf${orange}" && sleep 1.5
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

        bitcoin-cli -named createwallet wallet_name=jm_wallet descriptors=false 2>&1 | grep -q "exists" && break
        bitcoin-cli -named createwallet wallet_name=jm_wallet descriptors=false && enter_continue && break
        echo -e "$red
        Sometimes waiting for bitcoin to laod up is needed.
        Trying again every 10 seconds...$orange
        "
        sleep 10
    done

}

function run_wallet_tool_joinmarket {

    set_terminal
    echo -e "${green}Running Joinmarket wallet tool...${orange}"
    docker exec joinmarket bash -c '/jm/clientserver/scripts/wallet-tool.py' #do not exit on failure.
    enter_continue
    return 0
}

function modify_joinmarket_cfg {
    jmfile="/root/.joinmarket/joinmarket.cfg"
    source $bc

    docker exec joinmarket bash -c "sed -i '/rpc_cookie_file =/d' $jmfile"
    docker exec joinmarket bash -c "sed -i 's/rpc_wallet_file =/rpc_wallet_file = jm_wallet/' $jmfile"
    docker exec joinmarket bash -c "sed -i 's/rpc_user =/rpc_user = $rpcuser/' $jmfile"
    docker exec joinmarket bash -c "sed -i 's/rpc_password =/rpc_password = $rpcuser/' $jmfile"
    docker exec joinmarket bash -c "sed -i 's/onion_serving_port =/onion_serving_port = 8077/' $jmfile"
    return 0
}


function build_joinmarket {
    unset success
    rm $hp/joinmarket/Dockerfile >$dn 2>&1
    cp $pn/src/joinmarket/Dockerfile $hp/joinmarket/Dockerfile >$dn 2>&1
    cd $hp/joinmarket
    docker build -t joinmarket . && success="true"
    enter_continue
    if [[ $success == "true" ]] ; then return 0 ; else return 1 ; fi
}

function run_joinmarket_docker {

    docker run -d \
               --name joinmarket \
               -v $HOME/.joinmarket:/root/.joinmarket \
               --network="host" \
               --restart unless-stopped \
               joinmarket
    return 0
}

function clone_joinmarket {

    cd $hp && git clone --depth 1 https://github.com/JoinMarket-Org/joinmarket-clientserver.git joinmarket \
        || { announce "Something went wrong." && return 1 ; }

    return 0 
}

#### better to do this in Dockerfile with --docker-install flag
# function do_install_joinmarket {

#     set_terminal
#     echo -e "${green}Installing JoinMarket...${orange}"
#     docker exec joinmarket /jm/clientserver/install.sh --without-qt --disable-secp-check --disable-os-deps-check
#     enter_continue
#     return 0

# }

#### Don't need virtual env in docker container
# function activation_script_joinmarket {
#     set_terminal
#     echo -e "${green}Running Joinmarket activate script...${orange}"
#     docker exec joinmarket bash -c 'source /jm/clientserver/jmvenv/bin/activate && /jm/clientserver/scripts/wallet-tool.py'
#     enter_continue
# }
