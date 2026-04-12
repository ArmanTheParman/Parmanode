function make_eps_config {

mv $hp/eps/config.ini_sample $hp/eps/config.ini
gsed -i "s|.*rpc_user =.*|rpc_user = $rpcuser|g" $hp/eps/config.ini
gsed -i "s|.*rpc_password =.*|rpc_password = $rpcpassword|g" $hp/eps/config.ini
gsed -i "s|.*host =.*|host = 0.0.0.0|g" $hp/eps/config.ini
gsed -i "s|.*port =.*|port = 50009|g" $hp/eps/config.ini
gsed -i "s|.*certfile =.*|certfile = $hp/eps/cert.pem|g" $hp/eps/config.ini
gsed -i "s|.*keyfile =.*|keyfile = $hp/eps/cert.pem|g" $hp/eps/config.ini

}