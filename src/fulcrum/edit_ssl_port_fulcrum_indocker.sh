function edit_ssl_port_fulcrum_inpodman {

# any updates here will not be reflected in the user's container if they update the hose
# computers' parmanode version, without rebuilding the podman container.

nogsedtest
port="$1"
sudo gsed -i "/ssl/d" $fc
echo "ssl = 0.0.0.0:$port" >> $fc
}