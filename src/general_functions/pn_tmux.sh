function pn_tmux {
command="$1"
tmuxname="$2"
tmuxname=${tmuxname:-$(mktemp -u session-XXXXXX)}

if ! which tmux >$dn 2>&1 ; then 
yesorno "Need tmux for this to work. OK to install?" || return 1
fi

install_tmux #exits if installed

TMUX2=$TMUX ; unset TMUX ; clear


    if [[ $NODAEMON == "true" ]] ; then
        tmux new -s $tmuxname "$command"
    else #daemon
        if ! echo "$@" | grep sudo ; then 
            tmux new -s $tmuxname -d "$command"
        else
            sudo bash -c "exec tmux new -s '$tmuxname' -d '$command' >/dev/null 2>&1" >/dev/null 2>&1
        fi
    fi


TMUX=$TMUX2
return 0
}