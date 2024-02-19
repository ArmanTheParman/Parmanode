function menu_tools2 {

while true ; do
set_terminal_high
echo -e "
########################################################################################
  $cyan
                               P A R M A N O D E - Tools   $orange


              (curl)      Test bitcoin curl/rpc command (for troubleshooting)

              (rf)        Refresh Parmanode script directory              

              (sr)        System report (for getting troubleshooting help)
$orange
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal

case $choice in
    
q|Q) exit ;;  m|M) back2main ;; p|P) return 0 ;;

curl)
bitcoin_curl
return 0
;;

rf)
pn_refresh
return 0
;;

sr)
system_report
return 0
;;

*)
invalid 
;;
esac
done
return 0
}

function bitcoin_curl {
source $bc

while true ; do
set_terminal ; echo -en "
########################################################################################

    The curl command to the bitcoin daemon, to run in terminal is...
$cyan

curl --user $rpcuser:$rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }' -H 'content-type: text/plain;' http://$IP:8332
$orange
    Parmanode can run this command for you or you can copy/paste it yourself, and
    make edits as needed.
$green
               d)      Do it for me
$orange
            <enter>    I'll do it, moving on.

########################################################################################
"
choose "xpmq" ; read choice
set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; M|m) back2main ;;
"") break ;;
d)
curl --user $rpcuser:$rpcpassword --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }' -H 'content-type: text/plain;' http://$IP:8332
enter_continue
break
;;
*)
invalid
;;
esac
done
}

function pn_refresh {
while true ; do
set_terminal ; echo -e "
########################################################################################

    Sometimes, especially if you manually edit the code, updates to Parmanode
    might do strange things. You can get a fresh copy of the latest version of
    Parmanode without affecting any of the programs you installed or any configuration
    files - totally safe.
$green
                        rf)       Refresh Parmanode
$orange
                        a)        Abort

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 0 ;; m|M) back2main ;;
a|A) return 1 ;;
rf)
cd $HOME/parman_programs && rm -rf ./parmanode
git clone https://github.com/armantheparman/parmanode.git
success "The Parmanode script directory has been refreshed"
announce "Please quit and restart Parmanode to see changes take effect."
;;
*)
invalid
esac
done

}