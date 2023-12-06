function choose_mempool_tor {
export file="$hp/mempool/docker/docker-compose.yml"

set_terminal ; echo -e "
########################################################################################

    Turn on connection to Mempool via Tor?
$green
                                 y)      Yes
$red
                                 n)      No
   $orange       
######################################################################################## 
"
choose "x"
read choice
case $choice in
n) return ;;
esac
clear
swap_string "$file" "SOCKS5PROXY_ENABLED:" "SOCKS5PROXY_ENABLED: \"true\""

}