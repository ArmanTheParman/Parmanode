function make_socat_script {

if [[ $1 == electrs ]] ; then
#start script (run by service file)
echo "#!/bin/bash
socat OPENSSL-LISTEN:50006,reuseaddr,fork,cert=$hp/electrs/cert.pem,key=$hp/electrs/key.pem,verify=0 TCP:127.0.0.1:50055 > $dp/socat.log 2>&1 &
echo \"\$!\" > $dp/.socat1 
socat TCP-LISTEN:50055,reuseaddr,fork TCP:127.0.0.1:50005 > $dp/socat.log 2>&1 &
echo \"\$!\" > $dp/.socat2 
" | tee $dp/start_socat_electrs.sh >/dev/null

#stop script (run by service file)
echo "#!/bin/bash
kill -9 \$(cat $dp/.socat1)
kill -9 \$(cat $dp/.socat2)
" | tee $dp/stop_socat_electrs.sh >/dev/null

# make executable:
sudo chmod +x $dp/stop_socat_electrs.sh
sudo chmod +x $dp/start_socat_electrs.sh
fi

if [[ $1 == public_pool_ui ]] ; then
#start script (run by service file)
echo "#!/bin/bash
socat OPENSSL-LISTEN:3341,reuseaddr,fork,cert=$hp/public_pool_ui/cert.pem,key=$hp/public_pool_ui/key.pem,verify=0 TCP:127.0.0.1:3342 > $dp/socat.log 2>&1 &
echo \"\$!\" > $dp/.socat1_public_pool_ui
socat TCP-LISTEN:3342,reuseaddr,fork TCP:127.0.0.1:3343 > $dp/socat.log 2>&1 &
echo \"\$!\" > $dp/.socat2_public_pool_ui
" | tee $dp/start_socat_public_pool_ui.sh >/dev/null

#stop script (run by service file)
echo "#!/bin/bash
kill -9 \$(cat $dp/.socat1_public_pool_ui)
kill -9 \$(cat $dp/.socat2_public_pool_ui)
" | tee $dp/stop_socat_public_pool_ui.sh >/dev/null

# make executable:
sudo chmod +x $dp/stop_socat_public_pool_ui.sh
sudo chmod +x $dp/start_socat_public_pool_ui.sh
fi




}