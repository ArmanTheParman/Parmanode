function btcpay_mac_explanation {

set_terminal ; echo -e "
########################################################################################

    To make BTCPay Server work on Macs, some weird workarounds are needed. Not my 
    fault, it's Apple's fault.

    1)  Bitcoin needs to be uninstalled on the machine, but the data directories that
        Parmanode set up need to remain in place. In a new terminal window, 
        run Parmanode, and uninstall Bitcoin. When prompted, do not delete any of
        the data directories, and do not delete symplinks.

    2)  The BTCPay container will be built, and the data directory on the inside of
        container will be mounted (attached) to the existing data directory, wheter
        that's on the Mac's internal drive or an attached external drive (make sure
        any external drive remains attached an mounted during this process)

    3)  Bitcoin will then be installed inside the container

    4)  BTCPay server can then be run

$cyan
    
    When you have read this carefully and uninstalled Bitcoin as described, hit
    <enter>
$orange
########################################################################################
"
enter_continue
}