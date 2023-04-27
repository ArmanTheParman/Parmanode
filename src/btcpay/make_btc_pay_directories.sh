function make_btcpay_directories {

#delete existing; check with user.

if [ -d $HOME/.btcpayserver ] ; then 
    set_terminal
    echo "
    As a precaution, even thought BTCPay server is not fully installed using Parmanode,"
    echo "the existance of $HOME/.btcpayserver was checked for. It does exists, which"
    echo "is unexpected. Deleting..."

    choose "qc" ; read choice ; case $choice in q|Q) return 0 ;; esac
    rm -rf $HOME/.btcpayserver 
    installed_conf_remove "btcpay-end"
    fi

if [ -d $HOME/.nbxplorer ] ; then 
    set_terminal
    echo "
    As a precaution, even thought BTCPay server is not fully installed using Parmanode,"
    echo "the existance of $HOME/.nbxplorer was checked for. It does exists, which"
    echo "is unexpected. Deleting..."

    choose "qc" ; read choice ; case $choice in q|Q) return 1 ;; esac
    rm -rf $HOME/.nbxplorer
    installed_conf_remove "btcpay-end"
    fi

mkdir -p ~/.btcpayserver/Main ~/.nbxplorer/Main && \
  log "btcpay" ".btcpayserver mkdir success" && \
  installed_conf_add "btcpay-start" && \
  return 0 \
  || return 1 && log "btcpay" "mkdir .bitpayserver & .nbxploerer failed"
}