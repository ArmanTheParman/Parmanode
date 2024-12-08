function menu_bitcoin {
if ! grep -q "bitcoi.*end" $ic ; then return 0 ; fi
export debuglogfile="$HOME/.bitcoin/debug.log" 

if grep -q "btccombo" $ic >$dn 2>&1 ; then
dockerbitcoinmenu=" $pink                Bitcoin em contentor Docker com servidor BTCPay $orange"
btcman="$cyan      man)$orange          Explorar o contentor Bitcoin/BTCPay (manr para root)"
else
unset btcman dockerbitcoinmenu
fi

#for multiselection menus, need to exit if not installed
if ! grep -q "bitcoin-end" $HOME/.parmanode/installed.conf >$dn 2>&1 ; then return 1 ; fi

while true ; do

unset output1 output2 choice

if [[ -e $debuglogfile ]] && tail -n50 $debuglogfile | grep -q "Corrupt" ; then

    printthis="\r$(cat $debuglogfile | grep -n "Corrupt" | tail -n1)"
   
    announce "A Parmanode detectou um potencial erro grave no registo do Bitcoin.
    Esta notificação foi detectada pela seguinte linha encontrada no ficheiro 
    debug.log da bitcoin. Pode ser um falso positivo. Dê uma olhadela...
    $red
    $printthis
    $orange
    Uma opção pode ser re-indexar a blockchain (se necessário, procure-a), outra 
    pode ser apagar os dados e começar de novo - existe uma opção de menu 
    Parmanode para isso.

    Outra opção poderá ser tentar o velho truque de "desligar e voltar a ligar".

    Aconteceu-me isto algumas vezes e o velho truque de 'desligar e voltar a ligar' 
    resolveu o problema."
fi

bitcoin_status #get running text variable.
isbitcoinrunning 
   if [[ -e $debuglogfile ]] && tail $debuglogfile | grep -q "Encerramento: concluído" ; then bitcoinrunning="false" ; fi

source $oc
if [[ $bitcoinrunning != "false" ]] ; then running="true" ; fi
if [[ $bitcoinrunning == "true" ]] ; then

output1="                   Bitcoin is$green RUNNING$orange $running_text"
output2="                   Sincronização com a unidade$drive"
    if tail -n20 $HOME/.bitcoin/debug.log | grep -iq "encerramento em curso" ; then
    output1="                   Bitcoin está$bright_blue A ENCERRAR$orange"
    fi
    if tail -n1 $HOME/.bitcoin/debug.log | grep -iq "Encerramento: concluído" ; then
         output1="                   Bitcoin é$red NÃO está a correr$orange -- escolha \"start\" para correr"
         output2="                   Sincroniza-se com a unidade$drive"
    fi

else
output1="                   Bitcoin é$red NÃO está a correr$orange -- escolha \"start\" para correr"

output2="                   Sincroniza-se com a unidade$drive"
fi                         


if [[ $OS == Linux && $bitcoinrunning == "false" ]] && which bitcoin-qt >$dn 2>&1 ; then
output3="\n$green               qtstart)$orange      Iniciar o Bitcoin Qt \n"
fi

if [[ $OS == Linux && $bitcoinrunning == "true" ]] && pgrep bitcoin-qt >$dn 2>&1 ; then
output3="\n$red               qtstop)$orange       Parar o Bitcoin Qt \n"
fi

output4="                   Utilização de dados Bitcoin: $red$(du -shL $HOME/.bitcoin | cut -f1)"$orange

if [[ -z $drive ]] ; then unset output2 ; fi

if [[ $1 == "menu_btcpay" ]] ; then return 0 ; fi

if [[ $bitcoinrunning == "true" ]] && tail -n15 $HOME/.bitcoin/debug.log | grep -qi "Encerramento: Em curso" ; then
         output1="                   Bitcoin está$red A ENCERRAR$orange -- Aguarde"
         output2="                   Sincroniza-se com a unidade$drive"
fi

debug "bitcoin menu..."
set_terminal_custom "52"


echo -en "
########################################################################################
                                ${cyan}Menu do Bitcoin Core${orange}                               
$dockerbitcoinmenu
########################################################################################


"
echo -e "$output1"
echo ""
echo -e "$output2"
echo ""
echo -e "$output4"
echo -e ""
if ! ( [[ $bitcoinrunning == "true" ]] && pgrep bitcoin-qt >$dn 2>&1 ) ; then
echo -ne "
$green
               start)$orange        Iniciar Bitcoin
            $red
               stop)$orange         Parar o Bitcoin
            $cyan"

    if [[ $bitcoinrunning == "true" ]] ; then
        echo -ne "
               restart)$orange      Reiniciar a Bitcoin \n"
    fi
fi
echo -ne "$output3 $cyan
               n)$orange            Aceder à informação do nó Bitcoin 
            $cyan
               log)$orange          Bitcoin debug.log 
            $cyan
               bc)$orange           Inspecionar o ficheiro bitcoin.conf (bcv para vim)
            $cyan
               up)$orange           Definir, remover, ou modificar RPC user/pass
            $bright_blue
               tor)$orange          Opções do menu Tor para Bitcoin...
            $cyan
               mm)$orange           Migrar/reverter uma unidade externa...
            $cyan
               delete)$orange       Eliminar os dados da blockchain e começar de novo
            $cyan
               upd)$orange          Atualizar o assistente Bitcoin
            $cyan
               tips)$orange         Sugestões de Parman ...
         $btcman
         $cyan      o)$orange            OUTROS...

                                                               $red prima "r" para atualizar $orange
########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; m|M) back2main ;;
p|P)
if [[ $1 == overview ]] ; then return 0 ; fi
menu_use
;;
r)
set_terminal
continue
;;

m|M) back2main ;;

start|START|Start)
start_bitcoin
;;

stop|STOP|Stop)
stop_bitcoin
;;

restart|RESTART|Restart)
stop_bitcoin
start_bitcoin 
;;

c|C)
connect_wallet_info
continue
;;

n|N)
if ! grep -q "btccombo" $ic && [[ $OS == Mac ]] ; then no_mac ; continue ; fi

menu_bitcoin_cli
continue
;;

log|LOG|Log)
log_counter
if [[ $log_count -le 10 ]] ; then
echo -e "
########################################################################################
    
    Isto irá mostrar o ficheiro bitcoin debug.log em tempo real à medida que é preenchido.
    
    Pode premir$cyan <control>-c$orange para o fazer parar.

########################################################################################
"
enter_continue ; jump $enter_cont
fi
set_terminal_wider

if ! which tmux >$dn 2>&1 ; then
yesorno "A visualização de registos necessita do Tmux instalado. Pode fazer isso?" || continue
fi
TMUX2=$TMUX ; unset TMUX ; clear
tmux new -s -d "tail -f $HOME/.bitcoin/debug.log"
TMUX=$TMUX2

continue ;;

RU|Ru)
    umbrel_import_reverse
    ;;

bc|BC)
echo -e "
########################################################################################
    
        Isso executará o editor de texto$cyan Nano$orange para editar o bitcoin.conf. Veja os 
        controles na parte inferior para salvar e sair. Tenha cuidado ao mexer neste ficheiro.

        Quaisquer alterações só serão aplicadas quando reiniciar o Bitcoin.

########################################################################################
"
enter_continue ; jump $enter_cont
nano $HOME/.bitcoin/bitcoin.conf
continue
;;
bcv)
vim_warning
vim $HOME/.bitcoin/bitcoin.conf
;;

up)
set_rpc_authentication
continue
;;

tor|TOR|Tor)
menu_bitcoin_tor
continue
;;

mm|MM|Mm|migrate|Migrate)
menu_migrate
continue
;;

upd)
update_bitcoin
continue
;;

o|O)
menu_bitcoin_other || return 1
;;

qtstart)
if [[ -n $output3 && $bitcoinrunning == "false" ]] ; then
start_bitcoinqt
fi
;;

qtstop)
if [[ -n $output3 && $bitcoinrunning == "true" ]] ; then
stop_bitcoinqt
fi
;;

delete|Delete|DELETE)
stop_bitcoin
delete_blockchain
return 1
;;

man)
menu_btcpay_man
;;
manr)
menu_btcpay_manr
;;
tips)
bitcoin_tips
;;

*)
invalid
continue
;;
esac
done
return 0
}

function bitcoin_status {
if [[ ! -e $HOME/.bitcoin/debug.log ]] ; then return 1 ; fi
source ~/.parmanode/parmanode.conf >$dn 2>&1 #get drive variable
unset running output1 output2 height running_text

export height="$(tail -n 200 $HOME/.bitcoin/debug.log | grep version | grep height= | tail -n1 | grep -Eo 'height=[0-9]+\s' | cut -d = -f 2 | tr -d ' ')" 
#set $running_text

if [[ -n $height ]] ; then
export running_text="-- height=$height"
elif tail -n1 $HOME/.bitcoin/debug.log | grep -Eq 'Verification progress: .*$' ; then
export running_text="$( tail -n1 $HOME/.bitcoin/debug.log | grep -Eo 'Verification progress: .*$')"
elif tail -n2 $HOME/.bitcoin/debug.log | grep -q "thread start" ; then
export running_text="$(tail -n2 $HOME/.bitcoin/debug.log | grep -Eo '\s.*$')" 
#elif ... Waiting 300 seconds before querying DNS seeds
else 
export running_text="-- status ...type r to refresh, or see log"
fi

if [[ -n $height ]] ; then
    if tail -n50 $HOME/.bitcoin/debug.log | grep height= | tail -n1 | grep -qE 'progress=1.00' >$dn 2>&1 ; then
    export running_text="-- height=$height (fully sync'd)"
    else
    temp=$(tail -n50 $HOME/.bitcoin/debug.log | grep height= | tail -n1 | grep -Eo 'progress=0\.[0-9]+\s' | cut -d \. -f 2)
    export PC="${temp:0:2}.${temp:2:2}%"
    if [[ $PC == "00.00%" ]] ; then PC='' ; fi
    export running_text="-- height=$height ($PC)"
    fi
fi

if tail -n1 $HOME/.bitcoin/debug.log | grep -qEo 'Pre-synchronizing blockheaders' ; then
export running_text="-- Pre-synchronizing blockheaders"
return 0
fi

if tail -n1 $HOME/.bitcoin/debug.log | grep -qEo "Synchoronizing blockheaders" ; then
export running_text="Synchronizing blockheaders"
return 0
fi
}




function bitcoin_tips {
set_terminal_high ; echo -e "
########################################################################################$cyan
                          Dicas de uso do Parmanode Bitcoin$orange
########################################################################################


    É bom ver o que o Bitcoin está a fazer em tempo real. Veja o log a partir do menu. 
    Se o menu de registo estiver a dar problemas, podes vê-lo manualmente com 
    $cyan nano $HOME/.bitcoin/debug.log$orange

    A informação, como a altura do bloco, é capturada do ficheiro debug.log. Pode haver 
    falhas, mas não há problema, basta olhar para o registo e ler o progresso. O ficheiro 
    é preenchido com as adições mais recentes na parte inferior. 
    Quando vir $cyan progress=1.00000000$orange, sabe que está totalmente sincronizado.

    Se houver corrupção de dados, o Bitcoin não conseguirá iniciar. Lê o ficheiro de 
    registo e vê se indica corrupção de dados - terás de apagar e voltar a sincronizar. 
    O menu Parmanode Bitcoin tem uma ferramenta para isso.

    Se tiveres problemas em iniciar/parar o bitcoin, podes tentar fazê-lo manualmente.
    No Mac, utilize a GUI - clique no ícone no menu Aplicações. No Linux, faça $cyan sudo 
    systemctl COMMAND bitcoind$orange. Substitua COMMAND por start, stop, restart ou status.
    
    Se estiver a utilizar o contentor docker combinado BTCPay, reiniciar o contentor manualmente 
    será problemático, porque os numerosos programas não carregam automaticamente se o contentor 
    for simplesmente reiniciado. Em vez disso, pode entrar manualmente no contentor, fazer $cyan 
    pkill -15 bitcoind$orange, e reiniciá-lo com
    
        $cyan bitcoind -conf=/home/parman/.bitcoin/bitcoin.conf$orange

    Se você quiser mover o diretório de dados para outro lugar, primeiro dê uma olhada na opção 
    de menu${cyan}dfat$orange em Parmanode-->Tools, e veja como os links simbólicos funcionam. 
    Para mover ou copiar o diretório de dados, certifique-se de que o Bitcoin foi parado. 
    Então use a ferramenta $cyan rysync$orange do menu Parmanode-->Tools. 
    Esta ferramenta ajudá-lo-á a construir o comando correto.


########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; }
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
*)
return 0 
;;
esac

}
