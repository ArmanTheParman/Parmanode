function make_socat_script {

if [[ $1 == electrs ]] ; then
#start script (run by service file)
echo "#!/bin/bash
socat OPENSSL-LISTEN:50006,reuseaddr,fork,cert=$hp/electrs/cert.pem,key=$hp/electrs/key.pem,verify=0 TCP:127.0.0.1:50055 &
echo "$!" > $dp/.socat1 
socat TCP-LISTEN:50055,reuseaddr,fork TCP:127.0.0.1:50005 &
echo "$!" > $dp/.socat2 
" | tee $dp/start_socat_electrs.sh >/dev/null

#stop script (run by service file)
echo "#!/bin/bash
kill -9 $(cat $dp/.socat1)
kill -9 $(cat $dp/.socat1)
" | tee $dp/stop_socat_electrs.sh >/dev/null

# make executable:
sudo chmod +x $dp/stop_socat_electrs.sh
sudo chmod +x $dp/start_socat_electrs.sh
fi

}