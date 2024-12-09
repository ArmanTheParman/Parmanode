function menu_bitcoin_tor {

if ! which tor >$dn 2>&1 ; then set_terminal
install_tor
fi

if ! which tor >$dn 2>&1 ; then set_terminal
enter_continue "
    É necessário instalar o Tor primeiro. Abortar.
    "
    return 0
fi

while true ; do
unset tortext
source $dp/parmanode.conf >$dn 2>&1 

if [[ $bitcoin_tor_status == t ]] ; then
    local status_print="Tor enabled (option 2)"

elif [[ $bitcoin_tor_status == c ]] ; then
    local status_print="Clearnet (option 4)"

elif [[ $bitcoin_tor_status == tc ]] ; then
    local status_print="Clearnet & Tor (option 1)"

elif [[ $bitcoin_tor_status == tonlyout ]] ; then
    local status_print="Strict Tor, only out (option 3)"

fi


if sudo cat $macprefix/var/lib/tor/bitcoin-service/hostname >$dn && [[ $bitcoin_tor_status != c ]] ; then 
get_onion_address_variable bitcoin 
tortext="
$bright_blue    Onion adress: $ONION_ADDR
$orange
########################################################################################
"
else tortext="
########################################################################################
"
fi
set_terminal ; echo -e "
########################################################################################

$cyan                        Opções de Tor para Bitcoin (apenas Linux)   $orange


    Opção para alterar as definições do Bitcoin Tor. Nota que se usares o LND, ele pode 
    parar de funcionar e requerer algum tempo de reflexão (minutos) antes de o poderes 
    reiniciar manualmente com sucesso.

$cyan
    1)$orange    Permitir ligações Tor E ligações clearnet
                 - Ajuda-o a si e à rede em geral
$cyan
    2)$orange    Forçar ligações apenas Tor
                 - Extra privado mas apenas ajuda a rede Tor de nós
   $cyan 
    3)$orange    Forçar Tor apenas para ligações OUTWARD
                 - Só ajuda a si próprio e é a mais privada de todas as opções
                 - Pode ligar-se aos nós tor, mas eles não podem ligar-se a si
$cyan
    4)$orange    Tornar a Bitcoin pública (remover a utilização do Tor e manter a clearnet)
                 - Geralmente mais rápido e mais fiável


$bright_magenta    Current Status: $status_print$orange
$tortext"

choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; Q|q|quit|QUIT|Quit) exit 0 ;; p|P) return 1 ;;
"1")
    bitcoin_tor "torandclearnet" 
    check_bitcoin_tor_status #sets status in parmanode.conf
    break ;; 
"2")
    bitcoin_tor "toronly" 
    check_bitcoin_tor_status
    break ;;
"3")
    bitcoin_tor "toronly" "onlyout" 
    check_bitcoin_tor_status
    break ;;
"4")
    bitcoin_tor_remove 
    check_bitcoin_tor_status
    break ;;
*)
    invalid ;;
esac

done
}
