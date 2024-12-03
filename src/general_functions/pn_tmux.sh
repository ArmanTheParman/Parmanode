function pn_tmux {
command="$1"
tmuxname="$2"
tmuxname=${tmuxname:-$(mktemp -u session-XXXXXX)}


if ! which tmux >$dn 2>&1 ; then 
yesorno "Need tmux for this to work. Ok to install?" || return 1
fi

install_tmux #exits if installed

TMUX2=$TMUX ; unset TMUX ; clear
if [[ $NODAEMON == "true" ]] ; then
sudo tmux new -s $tmuxname "$command"
else
sudo tmux new -s $tmuxname -d "$command"
fi
TMUX=$TMUX2
return 0
}