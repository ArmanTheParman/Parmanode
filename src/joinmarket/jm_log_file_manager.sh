function jm_log_file_manager {
#truncates files every 5 days

if [[ $1 == "stop" ]] ; then
tmux kill-session -t jm_log_file_manager
return 0
fi

TMUX2=$TMUX ; unset TMUX
tmux new -s jm_log_file_manager -d "
while true ; do
sleep 10
file1=$HOME/.joinmarket/orderbook.log
file1temp=$file1.temp
exec 3> $file1temp #opens file

if [[ $(wc -l < $file1) -gt 5000 ]] ; then 
    tail -n5000 $file1 >&3 
    mv $file1temp $file1
fi
exec 3>&-

file1=$HOME/.joinmarket/yg_privacy.log
file1temp=$file1.temp
exec 3> $file1temp #opens file

if [[ $(wc -l < $file1) -gt 5000 ]] ; then 
    tail -n5000 $file1 >&3 
    mv $file1temp $file1
fi

exec 3>&-

sleep 432000 
done
"
TMUX=$TMUX2

}
