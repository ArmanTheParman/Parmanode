function need_docker_for_btcpay {

set_terminal ; echo "
########################################################################################

                         BTCPay on Parmanode needs Docker

    BTCPay will be installed inside a Docker container (a virtual computer) together 
    with its backend programs: NBXplorer and Postgres database. 

    Push ahead with Docker installation? (Will automoatically skip if Docker instaled)

                      y)      Yes, please, that'd be lovely

                      n)      No thanks, don't touch my computer

########################################################################################
"
choose "xpq" ; read choice
case $choice in Q|q|quit|QUIT|Quit) exit 0 ;; p|P) return 1 ;;
y|Yes|Y|yes)
docker="yes" && return 0 ;;
n|N|No|NO|no)
docker="no" && return 0 ;;
esac
}