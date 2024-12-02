function menu_tools {

while true ; do
set_terminal_high
echo -ne "
########################################################################################$cyan
                                  FERRAMENTAS - PAGINA 1  $orange
########################################################################################


$cyan              (cc)$orange    Assistente de atualização do firmware ColdCard             

$cyan              (d)$orange     Eliminar as suas preferências anteriores para ocultar determinados Parmanode
                      messages

$cyan              (dfat)$orange  Ferramenta de assistência ao formato da drive
 
$cyan              (md)$orange    Importar/Migrar/Reverter uma drive externa.

$cyan              (mm)$orange    Montar a drive Parmanode - apenas Linux

$cyan              (ip)$orange    Qual é o endereço IP do meu computador?

$cyan              (ppp)$orange   Ligar ao nó do Parman através do Tor ...

$cyan              (pn)$orange    ParmanodL - Criar um mircoSD para um Raspberry Pi
                                                                                      
$cyan              (ps)$orange    Informação do ParmaShell 

$cyan              (rs)$orange    Ferramenta AF Rsync fácil do Parman Novo

$cyan              (u)$orange     Atualizar o computador (apt-get para Linux, Homebrew para Macs)

$cyan              (um)$orange    Desmontar a drive externa Parmanode 
                      (parar Bitcoin/Fulcrum/Electrs se estiver a funcionar) - Apenas em Linux
$red $blinkon
         ...  (n)  Mais opções $blinkoff
$orange
########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

    n|next)
    menu_tools2
    ;;
    
    m|M) back2main ;;

    cc)
    colcard_firmware
    ;;

    ppp|PPP)

    connect_to_parman
    ;;

    pn|PN|Pn)
    get_parmanodl
    ;;

    ps|PS|Ps)
    parmashell_info
    return 0
    ;;

    u|U|up|UP|update|UPDATE|Update)
    if [[ $OS == "Linux" ]] ; then 
        update_computer silent
        enter_continue
        success "Your computer" "being updated"
    fi
    if [[ $OS == "Mac" ]] ; then 
        update_computer silent
        success "Your Mac" "being updated"
    fi
    ;;

    ip|IP|iP|Ip)
        IP_address
        return 0
        ;;
    d|D)
        rm $HOME/.parmanode/hide_messages.conf
        echo "Choices reset" ; sleep 0.6 
        ;;
    um|UM|Um)
        safe_unmount_parmanode menu
        ;;

    mm|MM|Mm|mount)
        mount_drive menu
        if mount | grep -q parmanode ; then
        announce "Drive mounted."
        fi
        ;;

      md|MD)
      menu_migrate
      ;;

      rs|RS)
      rsync
      ;;

      dfat|DFAT)
      format_assist
      ;;

    "")
        return 0 
        ;;

    *)
        invalid 
        ;;
    esac
done
return 0
}

function connect_to_parman {

set_terminal ; echo -e "
########################################################################################
$cyan
                            LIGAR AO NÓ DO PARMAN
$orange
    Isto é apenas para fins de emergência ou de teste. 
    Qual é o objetivo de ter um nó se vai ligar-se ao de outra pessoa?

    No entanto, esta opção está disponível para si, por precaução.
    Não posso prometer 100% de tempo de atividade, porque às vezes acontecem coisas.
    Se, por qualquer razão, os meus dados de ligação mudarem, serão renovados na
    Parmanode quando a Parmanode for actualizada.

    Prometo não recolher quaisquer dados ou espiar as suas transacções.
    Posso fazer esta promessa com confiança porque nem sequer sei como o fazer.
    O seu endereço IP será desconhecido porque está a ligar-se através do Tor.
    
    Terá de ajustar manualmente as definições da sua carteira e incluir 
    o seguinte endereço de cebola para se ligar ao meu servidor:
$green
    odqwla6mucxo6u7z5isxoxmiasjncph7wg7nc2eiby7cvk36qbm4imyd.onion:700${red}2$green:t 
$orange
    Tem de utilizar o número da porta a seguir ao endereço de cebola ou não conseguirá
    estabelecer ligação.

    Para a carteira Electrum, você deve ativar seu proxy Tor e deve adicionar a parte 
    \":t\" da porta 7002. Isto especifica TCP sobre Tor. (:s, para SSL não funciona).

    Para a Sparrow wallet, é necessário ter o SSL desativado e o proxy Tor ativado.

########################################################################################
"
enter_continue ; jump $enter_cont

}
