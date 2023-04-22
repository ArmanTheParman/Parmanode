function edit_user_pass_fulcrum_conf_indocker {
# called by edit_user_pass_fulcrum_conf_indocker (from within the container,
# all the scripts are copied there at Dockerbuild).o


# any updates here will not be reflected in the user's container if they update the hose
# computers' parmanode version, without rebuilding the docker container.

rpcuser=$1

rpcpassword=$2

delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "rpcuser"

delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "rpcpassword"

echo "rpcuser = $rpcuser" >> $HOME/parmanode/fulcrum/fulcrum.conf

echo "rpcpassword = $rpcpassword" >> $HOME/parmanode/fulcrum/fulcrum.conf

return 0
}