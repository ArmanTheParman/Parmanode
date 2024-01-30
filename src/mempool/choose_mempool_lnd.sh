function choose_mempool_LND {
export file="$hp/mempool/docker/docker-compose.yml"
set_terminal ; echo -e "
########################################################################################

    Turn on connection to LND (does nothing if you haven't installed LND)?
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

swap_string "$file" "LIGHTNING_ENABLED:" "      LIGHTNING_ENABLED: \"true\""
return 0
}
