function menu_bitcoin_other {
while true
do
set_terminal
source ~/.parmanode/parmanode.conf >$dn #get drive variable

unset running output1 output2 
if [[ $OS == Mac ]] ; then
    if pgrep Bitcoin-Q >$dn ; then running="true" ; else running="false" ; fi
else
    if ! ps -x | grep bitcoind | grep -q "bitcoin.conf" >$dn 2>&1 ; then running="false" ; fi
    if tail -n 1 $HOME/.bitcoin/debug.log | grep -q  "Shutdown: done" ; then running="false" ; fi 2>$dn
    if pgrep bitcoind >$dn 2>&1 ; then running="true" ; fi
fi


if [[ $bitcoinrunning != "false" ]] ; then running="true" ; fi

if [[ $bitcoinrunning == "true" ]] ; then
output1="                   Bitcoin está$green A CORRER$orange-- veja o menu de registo para o progresso"

output2="                         (Sincronização com a unidade$drive)"
else
output1="                   Bitcoin $red NÃO está a correr$orange -- escolha \"start\" para correr"

output2="                         (Sincroniza-se com a unidade$drive)"
fi                         

echo -e "
########################################################################################
                            ${cyan}Menu Bitcoin Core - OUTROS ${orange}                               
########################################################################################
"
echo -e "$output1"
echo ""
echo -e "$output2"
echo ""
echo -e "

$cyan
      (cd)$orange       Alterar a unidade de sincronização interna vs externa
$cyan
      (mp)$orange       Modificar a redução (prune)
$cyan
      (c)$orange        Como ligar a sua carteira...........(Caso contrário, não faz sentido)
$cyan
      (dd)$orange       Diretorio de dados do Backup/Restauro.................(Apenas instruções)
$cyan   
      (r)$orange        Erros? Tente --reindex blockchain...
$cyan
      (h)$orange        Hack Parmanode; dicas para a resolução de problemas.

########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
m|M) back2main ;;

cd|CD|Cd)
change_bitcoin_drive
return 0
;;

mp|MP)
modify_prune
;;

c|C)
connect_wallet_info
continue
;;

dd|DD)
echo -e "
########################################################################################
$cyan   
                          DIRECTÓRIO DE DADOS DE BACKUP DE BITCOIN    
$orange
    Se tiver uma unidade de reserva, é uma boa ideia fazer uma cópia do diretório de dados 
    da bitcoin de vez em quando. Isto pode fazer com que não tenha de esperar muito tempo 
    se alguma vez tiver dados corrompidos e precisar de voltar a sincronizar a blockchain.

    É VITAL que pares o bitcoind antes de copiares os dados, caso contrário não funcionará 
    corretamente quando chegar a altura de utilizar os dados com cópia de segurança, e é 
    provável que o diretório fique corrompido. Foste avisado.

    Pode copiar todo o diretório bitcoin_data.

    Pode também copiar o diretório chainstate, que é muito mais pequeno, e isto pode ser 
    tudo o que precisa se um dia houver um erro no chainstate. Este diretório é mais 
    pequeno e é mais viável fazer backups frequentes. Sugiro que o faça a cada 100.000 
    blocos ou mais, para além de ter uma cópia de segurança completa, se tiver espaço 
    em disco algures.

    Para copiar os dados, utilize os seus conhecimentos informáticos habituais para 
    copiar ficheiros. O diretório está localizado na unidade interna:

                        $HOME/.bitcoin

    ou unidade externa:

                LINUX :$cyan   /media/$(whoami)/parmanode/.bitcoin $orange
                MAC   :$cyan   /Volumes/parmanode/.bitcoin$orange

    Note que se tiver um disco externo para o Parmanode, o diretório interno $HOME/.bitcoin 
    é na realidade uma ligação simbólica (atalho) para o diretório externo.

########################################################################################
"
enter_continue ; jump $enter_cont
continue
;;

r|R|reindex)
reindex_bitcoin
return 0
;;

h)
hack_tips
;;

p|P)
return 1
;;

q|Q|Quit|QUIT)
exit 0
;;

*)
invalid
continue
;;

esac

done
return 0
}

function hack_tips {

set_terminal_custom 55 ; echo -e "
########################################################################################

    Se, por algum motivo, o Bitcoin não estiver a sincronizar com a unidade correta, 
    eis o que está a acontecer nos bastidores para o ajudar a ajustar.

       1)   O Bitcoin Core por padrão sincroniza para $green$HOME/.bitcoin$orange, a menos que especificado 
            de outra forma no bitcoin.conf (a localização padrão é diferente para Macs).

       2)   O Parmanode nunca altera este diretório padrão, em vez disso ele 'engana' o 
            Bitcoin Core. Para drives externos, o Parmanode irá colocar um link simbólico 
            (atalho) na localização de $green$HOME/.bitcoin$orange, apontando para o diretório 
            do drive externo que é$orange /media/$USER/parmanode/.bitcoin $orange para Linux e 
            $green /Volumes/parmanode/.bitcoin$orange para Macs.

       3)   Para Macs, a localização padrão para os dados do Bitcoin no disco interno é estranha 
            e longa (ainda pior no Windows), e para simplificar, eu fiz isso apontar para 
            $green$HOME/.bitcoin$orange em Macs. A partir daí, se um utilizador de Mac escolher ou mudar 
            para a unidade externa, então $green$HOME/.bitcoin$orange também se torna uma ligação simbólica, 
            apontando para a unidade externa. É bonito, não é? Eu acho que é.
       
       4)   Se procurares o diretório .bitcoin, normalmente não o verás, a não ser que conheças 
            os truques para mostrar ficheiros/diretórios ocultos (pergunta ao Google ou ao ChatGPT 
            se precisares de ajuda).

       5)   O Parmanode sinaliza a si próprio para que tipo de unidade (interna/externa) o 
            Bitcoin está a sincronizar escrevendo a linha 'drive=external' ou 'drive=internal' 
            no ficheiro$green $dp/parmanode.conf$orange

       6)   Se depois de fazer alguns ajustes não padronizados, o Parmanode se enganou, 
            pode adicionar a linha necessária ao ficheiro parmanode.conf. Isto ajudará a 
            que o menu do Parmanode seja apresentado corretamente, e que quaisquer outros 
            alertas/verificações funcionem corretamente.

       7)   Parmanode também adiciona uma linha sobre o drive no arquivo$red /etc/fstab$orange 
            em máquinas Linux. Isso é parte do processo de 'importação', para que o drive sempre 
            seja montado quando você reiniciar o computador, e o Bitcoin Core possa iniciar 
            corretamente. $red Eu recomendo fortemente que você não mexa com esse arquivo 
            $orange a não ser que você seja um super expert, porque ele pode quebrar seu 
            sistema operacional se você errar.

########################################################################################
"
enter_continue ; jump $enter_cont
return 0
}
