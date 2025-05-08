function menu_parmaview {
if ! grep -q "parmaview-end" $ic ; then return 0 ; fi
while true ; do 

set_terminal 38 100; echo -ne "
####################################################################################################$cyan
                                          ParmaView Menu            $orange                   
####################################################################################################

        $cyan
                    ws)$orange      Start WebSocket
        $cyan
                    wst)$orange     Stop WebSocket
        $cyan
                    ts)$orange      Send test signal through socket

####################################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; clear
case $choice in 
ws)
ps aux | grep websocket_server.py | grep -v tmux | grep -vq grep && { enter_continue "Server already running" ; continue ; }
pn_tmux "python3 $pn/src/ParmaView/websocket_server.py" "ws1" 
enter_continue "Websocket started in the background"
;;
wst)
tmux kill-session -t ws1
enter_continue "WS1 session stopped"
;;
ts)
{ echo "Hello World" | sendtosocket ; } && enter_continue "Message sent"
;;
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) menu_use ;; 
"")
continue ;;
*)
invalid
;;
esac
done
} 