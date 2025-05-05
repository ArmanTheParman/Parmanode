function menu_parmaview {
if ! grep -q "parmaview-end" $ic ; then return 0 ; fi
while true ; do 
if ! docker ps >$dn 2>&1 ; then
    dockerrunning="
                              ${red}Warning: Docker is not running${orange}
    "
else

   if ! docker ps | grep -qi parmaview ; then
   dockerrunning="
                              ${red}Warning: ParmaView container is not running${orange}
   " 
   else
   dockerrunning="
                              ${green}ParmaView is running${orange}
   " 
   fi

fi

set_terminal 38 100; echo -ne "
####################################################################################################$cyan
                                          ParmaView Menu            $orange                   
####################################################################################################

                              $dockerrunning 
$cyan
              ws)$orange      Start WebSocket
$cyan
             wst)$orange      Stop WebSocket
$cyan
              ts)$orange      Send test signal through socket
$cyan
               s)$orange      Stop the container
$cyan
              rs)$orange      Restart the container
$cyan
              rf)$orange      Refresh ParmaView (starts over and includes new updates)
$red
      ----------------------------------------------------------------------------------------
      EXPERT OPTIONS... $cyan
              u)$orange       Run an update of Parmanode and the OS inside the container$cyan
              r) $orange      Log into the container as root $blue   The password is 'parmanode'$cyan
              pm)$orange      Log into the container as parman $blue The password is 'parmanode'$red
      ----------------------------------------------------------------------------------------
$orange

####################################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; clear
case $choice in 
ws)
ps aux | grep websocket_server.py | grep -v tmux | grep -v grep && { enter_continue "Server already running" ; continue ; }
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
r|R) 
docker exec -it -u root parmaview /bin/bash ;;
pm) 
docker exec -it -u parman parmaview /bin/bash ;;
s) 
stop_parmaview ;;
rs) 
start_parmaview ;;
u) 
docker exec -it -u root parmaview bash -c "apt update -y && apt -y upgrade" 
echo "Update Parmanode..."
docker exec -it -u parman parmaview bash -c "cd /home/parman/parman_programs/parmanode ; git pull"
sleep 2
;;
rf)
parmaview_refresh
;;
"")
continue ;;
*)
invalid
;;

esac
done
} 

function start_parmaview {
docker start parmaview >$dn 2>&1
}
function stop_parmaview {
docker stop parmaview >$dn 2>&1
}