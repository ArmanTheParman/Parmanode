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

if ! which tor 2>/dev/null ; then
clear ; echo -e "
########################################################################################
    Please install Tor first. You can enable Mempool-Tor later.
########################################################################################
"
enter_continue
return 1
fi

swap_string "$file" "SOCKS5PROXY_ENABLED:" "      SOCKS5PROXY_ENABLED: \"true\""
enable_mempool_tor

}