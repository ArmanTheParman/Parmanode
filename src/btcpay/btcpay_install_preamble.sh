function btcpay_install_preamble {
yesorno "$cyan
                                Install BTCPay?
$orange
    BTCPay Server is a self-hosted, open-source bitcoin payment processor. It will
    connect to your own Bitcoin Core node and LND node.

    Please be aware that if this is the first time installing BTCPay on this computer,
    it make take a while as it compiles from source within a Docker Container. If you
    have installed it before, this installation will used cached files so it is 
    likely to be a lot faster. 

    Proceed?" && return 0
    return 1
}