function menu_btcpay {
while true ; do
set_terminal ; echo "
########################################################################################

                                  BTCPay Server

    BTCPay server is available to you via your browser on this computer. Enter the
    following address to access:

                  http://


                  start)        start BTCPay Server (via docker container start) 
                                                    - rarely this is needed

                  stop)         stop BTCPay Serve (via docker container start)r
                                                    - rarely this is needed
 
                  l)            view log
                  
                  


"



done
return 0
}