function set_user_pass_fulcrum_docker {

docker exec -d fulcrum /home/parman/parmanode/src/text_functions

echo "rpcuser = $rpcuser" | tee -a /home/parman/parmanode/fulcrum/fulcrum.conf 

}