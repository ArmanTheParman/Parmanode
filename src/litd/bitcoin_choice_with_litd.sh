
function bitcoin_choice_with_litd {
while true ; do
set_terminal ; echo -e "
########################################################################################

    You have a choice to use a local installation of Bitcoin (bitcoind) to use with 
    litd, or you can choose to connect to one not running on this particular machine.
$green
                local)$orange     Bitoind on local machine
$bright_blue
                remote)$orange    Bitcoind on another machine

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;;
local)
export bitcoin_choice_with_litd=local
break
;;
remote)
export bitcoin_choice_with_litd=remote
set_remote_bitcoin_ip || return 1
break
;;
*)
invalid
;;
esac
done
}

function set_remote_bitcoin_ip {

while true ; do

clear ; echo -e "
########################################################################################

    Please type in the$pink IP address$orange of the Bitcoin Core instance you want to use, then
    hit$cyan <enter> $orange

########################################################################################
"
read ipcore

while true ; do
clear ; echo -e "
########################################################################################    
   
    Next, enter the rpc username for the Bitcoin Core instance.
    
    This can be found in it's corresponding bitcoin.conf file. If it doesn't exist,
    then Bitcoin Core doesn't have a username set up. You can create one by adding it
    to the bitcoin.conf file:
$yellow
                rpcuser=some_username
                rpcpassword=somepassword
$orange
    Then save and restart Bitcoin.
   $green 
    Type in the username then <enter>
$orange
########################################################################################
"
choose xpmq ; read remote_user ; set_terminal
case $remote_user in 
q|Q) exit ;; P|p|a) return 1 ;; M|m) back2main ;;
"") 
invalid
;;
*)
break
;;
esac
done

clear
echo -e "
########################################################################################

   Now type in the$cyan rpcpassword$orange (found in the corresponding bitcoin.conf file) then
   hit$green <enter> $orange

########################################################################################
"
read remote_pass


set_terminal ; echo -e "
########################################################################################

    These are your entries...


        IP address:   $ipcore

        rpcuser:      $remote_user

        rpcpassword:  $remote_pass
$green
$blinkon
    Please make sure the following lines are in the bitcoin.conf file of the remote
    Bitcoin installation, or you'll get errors: $blinkoff
$pink
                        zmqpubrawblock=tcp://*:28332
                        zmqpubrawtx=tcp://*:28333 
$orange
    Hit$green <enter>$orange to accept, or$red x-<enter>$orange to try again.

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
"")
break
;;
*)
continue
;;
esac
done

}
