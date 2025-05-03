function sendtosocket {
    if [[ -t 0 ]]; then
        # If stdin is a terminal, use argument
        echo "$1" | socat - UNIX-CONNECT:"$HOME/.parmanode/parmanode.sock"
    else
        # If stdin is piped, forward it directly
        socat - UNIX-CONNECT:"$HOME/.parmanode/parmanode.sock"
    fi
}
