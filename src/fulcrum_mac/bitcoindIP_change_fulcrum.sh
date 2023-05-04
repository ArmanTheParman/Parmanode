function bitcoindIP_change_fulcrum {

while true ; do
set_terminal ; echo "
########################################################################################

                            IP address of Bitcoin Core

    Go get the IP address of the other Bitcoin Core computer that Fulcrum will 
    connect to.

    (The standard port of 8332 will be assumed. You must fiddle with this yourself if 
    you want extra tinkering - Parmanode can't help you with it.)

########################################################################################

Type the IP address number (e.g. 192.168.0.150):  "
read IP
echo "
The address you typed is : $IP

Hit (y) and <enter> to accept, or (n) to try again.
"
read choice
case $choice in y|Y) break ;; n|N) continue ;; *) invalid ;; esac
done

    edit_bitcoindIP_fulcrum_indocker $IP

return 0
}