function pn_tmux {
command="$1"
tmuxname="$2"
tmuxname=${tmuxname:-$(mktemp -u session-XXXXXX)}


if ! which tmux >$dn 2>&1 ; then 
yesorno "Need tmux for this to work. Ok to install?" || return 1
fi

install_tmux #exits if installed

TMUX2=$TMUX ; unset TMUX ; clear
sudo tmux new -s $tmuxname -d "$command"
TMUX=$TMUX2
}