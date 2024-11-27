function pn_tmux {
command="$1"

if ! which tmux >$dn 2>&1 ; then 
yesorno "Need tmux for this to work. Ok to install?" || return 1
fi

install_tmux #exits if installed

TMUX2=$TMUX ; unset TMUX ; clear
tmux new -s -d "$command"
TMUX=$TMUX2
}