function check_socat_working {

if tmux ls | grep -q joinmarket_socat ; then 
socatstatus="${green}RUNNING$orange" 
else 
socatstatus="${red}NOT RUNNING$orange"
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
enter_continue ; jump $enter_cont

}