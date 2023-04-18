function menu_fulcrum {
while true
do
set_terminal
echo "
########################################################################################
                                   Fulcrum Menu                               
########################################################################################


      (start)    Start Fulcrum ............................................(Do it)

      (stop)     Stop Fulcrum ..................(One does not simply stop Bitcoin)

      (c)        How to connect your Electrum wallet to Fulcrum
	    
      (d)        Inspect Fulcrum logs

      (bc)       Inspect and edit fulcrum.conf file 

      (pw)       Set/remove/change Bitcoin rpc user/pass in Fulcrum config file


########################################################################################
"
choose "xpq" ; read choice ; set_terminal

case $choice in
start | START)
set_terminal
echo "Fulcrum starting..."
sudo systemctl start fulcrum.service
enter_continue
;;
stop | STOP) 
set_terminal
echo "Fulcrum stopping"
enter_continue
;;
c|C)
electrum_wallet_info
continue
;;



