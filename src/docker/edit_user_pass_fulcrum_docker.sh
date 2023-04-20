function set_user_pass_fulcrum_docker {

#from the host machine
rpcuser=$(grep -w "rpcuser" $HOME/.bitcoin/bitcoin.conf | awk -F '=' '{print $2}')
rpcpassword=$(grep -w "rpcpassword" $HOME/.bitcoin/bitcoin.conf | awk -F '=' '{print $2}')

docker exec -d fulcrum /bin/bash -c "edit_user_pass_fulcrum_conf_indocker $rpcuser $rpcpassword"

}

