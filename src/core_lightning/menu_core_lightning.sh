function menu_core_lightning {

if ! grep -q "cln-end" $ic ; then return 1 ; fi

while true ; do
set_terminal

#GET CLN VERSION
cln_version=$(lightning-cli getinfo | jq -r .version)

if systemctl is-active --quiet core-lightning ; then
clnrunning="                                   CLN is$green RUNNING"
else
clnrunning="                                   CLN is$red NOT RUNNING"
fi

set_terminal 45 88 ; echo -e "
########################################################################################$cyan
                                CLN Menu$orange - $cln_version                               
########################################################################################$orange

$clnrunning

$cyan
                       start)$orange       Start CLN
$cyan
                        stop)$orange       Stop CLN
$cyan
                     restart)$orange       Restart CLN
$cyan                
                         log)$orange       See CLN logs in real time
$cyan
                        conf)$orange       Edit config (confv for vim)


########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal

case $choice in 

m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;;
"") continue ;;

s|S|start|START|Start) 
start_cln  ; continue 
;;

stop|STOP|Stop) stop_cln ; continue 
;; 

rs|RS|Rs|restart|RESTART|Restart) restart_cln ; continue 
;;


log|LOG|Log)
log_counter

if [[ $log_count -le 10 ]] ; then
echo -e "
########################################################################################
    
    This will show the log output for CLN in real-time as it populates.
    
    You can hit$cyan <control>-c$orange to make it stop.

########################################################################################
"
enter_continue
fi

set_terminal 38 200
if ! which tmux >$dn 2>&1 ; then
yesorno "Log viewing needs Tmux installed. Go ahead and do that?" || continue
fi
TMUX2=$TMUX ; unset TMUX ; clear
tmux new -s cln_log "tail -f ~/.lightning/log"
TMUX=$TMUX2
please_wait
;;

conf)

echo -e "
########################################################################################
    
        This will run Nano text editor to edit $clnconf. 
        See the controls at the bottom to save and exit. Be careful messing around 
        with this file.

$green
	  *** ANY CHANGES WILL ONLY BE APPLIED ONCE YOU RESTART CLN ***
$orange
########################################################################################
"
enter_continue ; jump $enter_cont
nano $clnconf
please_wait
continue 
;;

confv)

vim_warning ; vim $clnconf
please_wait
continue 
;;

esac
done

}