function make_btcpay_directories {

#delete existing; check with user.

if [ -d $HOME/.btcpayserver ] ; then 
    set_terminal
    echo "$HOME/.bitcpayserver directory exists. Deleting..."
    choose "qc" ; read choice ; case $choice in q|Q) return 1 ;; esac
    installed_conf_remove "btcpay-end"
    fi

if [ -d $HOME/.nbxplorer ] ; then 
    set_terminal
    echo "$HOME/.nbxplorer directory exists. Deleting..."
    choose "qc" ; read choice ; case $choice in q|Q) return 1 ;; esac
    fi

mkdir -p ~/.btcpayserver/Main ~/.nbxplorer/Main && \
  log "btcpay" ".btcpayserver mkdir success" && \
  installed_conf_add "btcpay-start" && \
  return 0 \
  || return 1 && log "btcpay" "mkdir .bitpayserver & .nbxploerer failed"
}