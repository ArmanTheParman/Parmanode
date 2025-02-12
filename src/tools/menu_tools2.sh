function menu_tools2 {

while true ; do
set_terminal_high
echo -en "
########################################################################################$cyan
                                   TOOLS - PAGE 2  $orange
########################################################################################


$cyan              bd)$orange        Install Bitcoin to a running Docker container

$cyan              as)$orange        AutoSSH reverse proxy tunnel guide

$cyan              curl)$orange      Test bitcoin curl/rpc command (for troubleshooting)

$cyan              gc)$orange        RPC call test to LND (grpcurl)

$cyan              rest)$orange      REST protocol test to LND (info only)

$cyan              rf)$orange        Refresh Parmanode script directory              

$cyan              pass)$orange      Change computer login/sudo password

$cyan              qr)$orange        QRencode command line tool (Linux and Mac)

$cyan              uo)$orange        UTXOracle                                                    

$orange
########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;;  m|M) back2main ;; p|P) return 0 ;;

bd)
install_bitcoin_docker
return 0
;;

curl)
bitcoin_curl
return 0
;;

gc)
grpccurl_call
;;

rf)
parmanode_refresh
return 0
;;


rest)
rest_protocol_test
;;

as)
autossh_setup
;;

uo)
announce "This is a decentralised Bitcoin Price Calculator.
    Bitcoin needs to be running for it to work.
    Use$cyan <control> c$orange to exit it."
NODAEMON=true
pn_tmux "python3 $pn/src/tools/UTXOracle.py 
    echo 'hit <enter> to continue' ; read" "UTXOracl"
unset NODAEMON
;;

pass)
set_terminal
yesorno "Are you sure you want to change your computer's password? If yes, you'll
    first be asked for the old password, then the new one twice." || continue
passwd && success "The password has been changed."
;;


qr)
which qrencode >$dn || install_qrencode || continue
menu_qrencode
;;

*)
invalid 
;;
esac
done
return 0
}

