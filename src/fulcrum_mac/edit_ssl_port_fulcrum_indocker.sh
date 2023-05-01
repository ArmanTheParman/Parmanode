function edit_ssl_port_fulcrum_indocker {

# any updates here will not be reflected in the user's container if they update the hose
# computers' parmanode version, without rebuilding the docker container.

port="$1"


delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "ssl"

echo "ssl = 0.0.0.0:$port" >> $HOME/parmanode/fulcrum/fulcrum.conf

return 0
}