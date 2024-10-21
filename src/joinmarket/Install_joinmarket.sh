function install_joinmarket {

    set_terminal

    if [[ $(uname) == Darwin ]] ; then no_mac ; return 1 ; fi

    grep -q "bitcoin-end" < $ic || { 
        announce "Please install Bitcoin first. Aborting." && return 1 
        }

    make_joinmarket_wallet || { enter_continue "aborting" ; return 1 ; }

    mkdir -p $HOME/.joinmarket >$dn 2>&1 && installed_conf_add "joinmarket-start"

    clone_joinmarket || { enter_continue "aborting" ; return 1 ; }

    build_joinmarket || { enter_continue "aborting" ; return 1 ; }

    run_joinmarket_docker || { enter_continue "aborting" ; return 1 ; }

    run_wallet_tool_joinmarket || { enter_continue "aborting" ; return 1 ; }

    modify_joinmarket_cfg || { enter_continue "aborting" ; return 1 ; }

    parmashell_4_jm

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
    return 0
}

function modify_joinmarket_cfg {
    jmfile="/root/.joinmarket/joinmarket.cfg"
    source $bc
#    enter_continue "rpcuser: $rpcuser, rpcpassword: $rpcpassword"
    docker exec joinmarket bash -c "sed -i '/rpc_cookie_file =/d' $jmfile"
    docker exec joinmarket bash -c "sed -i '/rpc_wallet_file =/c\\rpc_wallet_file = jm_wallet' $jmfile"
    docker exec joinmarket bash -c "sed -i '/rpc_user =/c\\rpc_user = $rpcuser' $jmfile"
    docker exec joinmarket bash -c "sed -i '/rpc_password =/c\\rpc_password = $rpcuser' $jmfile"
    docker exec joinmarket bash -c "sed -i '/onion_serving_port =/c\\onion_serving_port = 8077' $jmfile"
    return 0
}


function build_joinmarket {
    unset success_build #do not use 'success' as a variable, it deletes the success function
    rm $hp/joinmarket/Dockerfile >$dn 2>&1
    cp $pn/src/joinmarket/Dockerfile $hp/joinmarket/Dockerfile >$dn 2>&1
    cd $hp/joinmarket
    docker build -t joinmarket . && success_build="true"
    enter_continue
    if [[ $success_build == "true" ]] ; then return 0 ; else return 1 ; fi
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

function parmashell_4_jm {

cat << EOF | tee /tmp/b1 >$dn 2>&1
export LS_OPTIONS='--color=auto'
eval "$(dircolors)"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
EOF

cat /tmp/b1 $pn/src/ParmaShell/parmashell_functions > /tmp/b2

docker cp /tmp/b2 joinmarket:/root/.bashrc
}