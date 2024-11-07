function check_socat_working {

while true ; do
if tmux ls | grep -q joinmarket_socat ; then 
socatstatus="${green}RUNNING$orange (type 'stop' to stop)" 
else 
socatstatus="${red}NOT RUNNING$orange (type 'start' to start)"
fi

if [[ $do_return == "true" ]] ; then #so the above variables are set when returning from the case options
unset do_return
return
fi

set_terminal ; echo -e "
########################################################################################

    Socat runs in a tmux session in the background and takes traffic comming in on 
    port 61000 and delivers it to the port 62610, which is the order book server's
    port listening for connecitons. Some sort of middle handpassing of traffic is 
    necessary like this to get to the order book server from a different computer.

    If you don't understand any of that, don't worry about it, just make sure it's
    running if you want external access.

    Socat/Tmux is currently: $socatstatus


########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
"") return ;;
start)
start_socat joinmarket
do_return="true"
;;
stop)
stop_socat joinmarket
do_return="true"
;;
*)
invalid
;;
esac
done
}