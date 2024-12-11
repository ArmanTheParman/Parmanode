function update_bitcoin {

if grep -q "btccombo" $ic ; then
local version="$(docker exec btcpay bitcoin-cli --version | head -n 1)"
elif [[ $OS == Linux ]] ; then
local version="$(/usr/local/bin/bitcoin-cli --version | head -n 1)"
elif [[ $OS == Mac ]] ; then
local version="${green}Bitcoin para Mac OS, consulte a GUI para obter a versão$orange"
fi

set_terminal ; echo -e "
########################################################################################

    Então, queres atualizar o Bitcoin? Okie dokie.

    Está atualmente a executar isto:
    
    $cyan$version$orange

    Isto é o que se faz....
$cyan
        1)$orange   Desinstale o Bitcoin a partir do menu Parmanode.$red Certifique-se de que 
             NÃO apaga os dados da sua blockchain, a menos que queira começar de novo.$orange
$cyan
        2)$orange   Parar todos os serviços que estejam a comunicar com a Bitcoin (electrs, 
             Fulcrum LND, etc.)
$cyan
        3)$orange   Certifique-se de que tem a versão mais recente do Parmanode (selecione 
             update no menu principal).
$cyan
        4)$orange   Instalar novamente o Bitcoin (menu principal -> adicionar -> bitcoin)
$cyan
        5)$orange   Se estiver a sincronizar com a unidade externa, quando lhe for pedida 
             uma unidade, escolha a opção 3, 'importar unidade parmanode anterior'.
$cyan
        6)$orange   Continue a instalação - ser-lhe-ão dadas opções para escolher a versão 
             que pretende.
    $cyan        
        7)$orange   Executar Bitcoin.
$cyan
        8)$orange   Sente-se e relaxe enquanto derrubamos o sistema financeiro antigo e 
             as sanguessugas malvadas que o dirigem (não lhes chame "elite").

########################################################################################
"
enter_continue
jump $enter_cont
}
