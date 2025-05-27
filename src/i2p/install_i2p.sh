function install_i2p {
if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                   Install I2P
$orange    
    Parmanode will install the I2P daemon (It's not a browser) which will run in the 
    background.

########################################################################################    
"
choose "epq" ; read choice
jump $choice 
case $choice in Q|q|Quit|QUIT) exit 0 ;; p|P) return 1 ;; "") break ;; *) invalid ;; esac ;
done

set_terminal
sudo apt-get install -y default-jre 
mkdir -p $hp/i2p ; cd $hp/i2p
curl -LO https://geti2p.net/en/download/2.8.2/clearnet/https/files.i2p-projekt.de/i2pinstall_2.8.2.jar
java -jar i2pinstall_2.8.2.jar
./i2prouter start

success "I2P installed. Access via: http://127.0.0.1:7657"

}

function menu_i2p {
while true ; do
set_terminal ; echo -e "
########################################################################################$cyan
                                   I2P Menu$orange
########################################################################################

$cyan
                      start)$orange           Start I2P daemon
$cyan
                       stop)$orange           Stop I2P daemon
    

########################################################################################
"
choose "xpmq" ; read choice
jump $choice
case $choice in q|Q) exit  0 ;; m|M) back2main ;; p|P) return 1 ;;
start)
        $hp/i2p/i2prouter start
;;
stop)
        $hp/i2p/i2prouter stop
;;  
*)
invalid
;;
"")
continue
;;
esac
done

}