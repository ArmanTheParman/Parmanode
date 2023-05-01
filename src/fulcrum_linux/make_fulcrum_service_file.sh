function make_fulcrum_service_file {
set_terminal

echo "
########################################################################################

    A Fulcrum service file in /etc/systemd/system/ will be created in order to 
    instruct Fulcrum to start automatically after a reboot.

########################################################################################
"
enter_continue

#check if service file already exists

if [[ -e /etc/systemd/system/fulcrum.service ]]
then

while true
do
set_terminal
echo "
########################################################################################
    
        A fulcrum.service file named \"fulcrum.service\" already exists. 

	    Would you like to (r) to replace or (s) to skip (use current)?

########################################################################################
"
choose "xq" 
read choice
set_terminal

case $choice in
r|R)
    break
    ;;
s|S)
    echo "skipping..."
    enter_continue
    return 0
    ;;
q|Q)
    exit 0
    ;;
*)
    invalid
    ;;

esac
done
fi

# inner while loop's break reaches here, otherwise exits with return=1

# make fulcrum.service and add this text...
echo "[Unit]
Description=Fulcrum_daemon
After=network-online.target
Wants=network-online.target

[Service]
ExecStartPre=$HOME/.parmanode/mount_check.sh
ExecStart=/usr/local/bin/Fulcrum $HOME/parmanode/fulcrum/fulcrum.conf

User=$(whoami)
Group=$(id -ng)

[Install]
WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/fulcrum.service > /dev/null \
&& log "fulcrum" "service file made"

#tee used instead of echo because redirection operator after sudo echo loses sudo privilages

sudo systemctl daemon-reload 
sudo systemctl disable fulcrum.service >/dev/null 2>&1
sudo systemctl enable fulcrum.service >/dev/null 2>&1

return 0
}

