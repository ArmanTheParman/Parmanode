function import_bitcoin_install {
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                               FERRAMENTA DE IMPORTAÇÃO DE BITCOIN

$orange
    Com esta ferramenta, se já tiveres Bitcoin instalado no teu sistema, podes 
    simplesmente trazê-lo para que o Parmanode o reconheça.

########################################################################################
"
choose "epmq" read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;; "") break ;; *) invalid ;;
esac
done

while true ; do
set_terminal ; echo -e "
########################################################################################

    O Parmanode irá parar o funcionamento do bitcoin (se estiver a funcionar) com o comando:
   $green 
        bitcoin-cli stop
       $orange 

    Carrega em$pink <enter>$orange para continuar (não importa se a bitcoin não está a 
    funcionar neste momento).

########################################################################################
"
choose "epmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;; "") break ;; *) invalid ;;
esac
done

if [[ ! -f /usr/local/bin/bitcoind && ! -f /usr/local/bin/bitcoin-cli ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    O Parmanode não detectou o bitcoind e o bitcoin-cli no diretório esperado:
$green
        /usr/local/bin
$orange
    Abre uma nova janela de terminal e move esses ficheiros binários (e outros como 
    bitcoin-qt e bitcoin-tx, se os tiveres) para a diretoria acima.

    Eu espero.

    Em seguida, prima$pink <enter>$orange para continuar.

########################################################################################
"
choose "epmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;; "") break ;; *) invalid ;;
esac
done
else

while true ; do
set_terminal ; echo -e "
########################################################################################

    O Parmanode detectou ficheiros binários Bitcoin em$green /usr/local/bin$orange

    Se estes não são os ficheiros que pretende utilizar, então abra um novo terminal e 
    mova os seus binários alvo para esta localização. Você precisa dos ficheiros:
$green
        bitcoind  $orange
        & $green
        bitcoin-cli
   $orange 
    no diretório /usr/local/bin

    Quando isso estiver feito, prima$pink <enter>$orange para continuar o assistente.

########################################################################################
"
choose "epmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;; "") break ;; *) invalid ;;
esac
done
fi


unset drive
while true ; do
set_terminal ; echo -e "
########################################################################################

    Agora precisamos de decidir sobre a localização dos dados do bloco Bitcoin.

    Queres...
$cyan
        1)$orange    Começar de novo com uma drive externa$red (formatar drive)$orange
$cyan
        2)$orange    Começar de novo com uma drive interna
$cyan
        3)$orange    Utilize os seus dados existentes a partir de uma drive externa
$cyan
        4)$orange    Utilize os seus dados existentes a partir de uma drive interna
$cyan
        5)$orange    Utilize os seus dados existentes de uma drive externa Parmanode

########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P|m|M) back2main ;;
1)
# Some variables to control how functions branch, esp install_bitcoin and children.
export drive=external  && parmanode_conf_add "drive=external"
export justFormat="true"
export version=self
install_bitcoin || return 1
break
#format_ext_drive "Bitcoin" #is the drive mounted here?
#prune_choice || return 1
#make_bitcoin_directories
#make_bitcoin_conf
#make_mount_check_script
#make_bitcoind_service_file
;;

2)
export drive=internal && parmanode_conf_add "drive=internal"
export version=self
install_bitcoin || return 1
break
;;

3)
export version=self
export drive=external 
parmanode_conf_add "drive=external"
export bitcoin_drive_import="true" #borrowed variable, can't use importdrive (variable gets unset)
export skip_formatting="true"
export make_label=parmanode
add_drive || return 1 # imports drive and makes directories if they don't exist.
#need to find the bitcoin directory
dir_not_found #?
#need to decide about bitcoin conf
replace_bitcoin_conf || return 1
message_move #move files before continuing

#functions needed from install_bitcoin:
#make_mount_check_script
#make_bitcoind_service_file
#set_rpc_authentication (if rpcuser not set)
install_bitcoin
break
;;

4)
export version=self
export drive=internal ;
parmanode_conf_add "drive=internal"
export bitcoin_drive_import="true" 
#need to decide about bitcoin conf
replace_bitcoin_conf || return 1
message_move #move files before continuing

#functions needed from install_bitcoin:
#make_mount_check_script
#make_bitcoind_service_file
#set_rpc_authentication (if rpcuser not set)
install_bitcoin
break
;;
5)
export version=self
export drive=external 
parmanode_conf_add "drive=external"
export bitcoin_drive_import="true" 
export skip_formatting="true"
menu_migrate parmy || return 1 # drive is detected, fstab added, directories made if non existant.
#need to find the bitcoin directory
dir_not_found #?

#functions needed from install_bitcoin:
#make_mount_check_script
#make_bitcoind_service_file
#set_rpc_authentication (if rpcuser not set)
install_bitcoin
break
;;
*)
invlalid ;;
esac
done
}


function dir_not_found {

if [[ $drive == external ]] ; then ############### for tracking nested if... can't indent because echo statements
default="$parmanode_drive/.bitcoin"

if ! grep -q "electrs" $dp/.temp ; then
text1="
    ${cyan}The same is true for $paranode_drive/electrs_db$orange"
fi

if ! grep -q "fulcrum" $dp/.temp ; then
text2="
    ${cyan}The same is true for $paranode_drive/fulcrum_db$orange"
fi

elif [[ $drive == internal ]] ; then ###############
default="$HOME/.bitcoin"
else ###############
announce "an error has occured. No drive variable found. Caution. Control-c
    to quit."
return 1
fi ###############



if ! grep -q "bitcoin" $dp/.temp ; then #this means mkdir didn't fail, and .bitcoin dir didn't exist initially

set_terminal ; echo -e "
########################################################################################

    O Parmanode não detectou um diretório de dados Bitcoin na sua localização predefinida:
$cyan
        $default
$orange
    Repare no "." que significa que é uma diretoria oculta. A Parmanode criou este diretório 
    para você, mas ele está vazio. Se quiseres que o Parmanode sincronize os dados do 
    Bitcoin em cima dos dados que já tens, então ENQUANTO O BITCOIN ESTÁ PARADO, copia os 
    teus dados existentes para a localização acima, depois inicia o bitcoin a partir do menu 
    Bitcoin do Parmanode.
    $text1
    $text2
########################################################################################
"
enter_continue
fi
}

function replace_bitcoin_conf {
#expecting only to be called if export_bitcoin_drive=true

while true ; do
set_terminal ; echo -e "
########################################################################################

    Recomenda-se que use o ficheiro bitcoin.conf da Parmanode, mas pode recusar e usar o 
    seu próprio ficheiro, mas certifique-se de que está no diretório de dados .bitcoin 
    antes de iniciar o bitcoin.

    Você escolhe...
$green
            1)    Usar o bitcoin.conf do Parmanode (recomendado)
$orange 
            2)    Use seu próprio arquivo bitcoin.conf de merda, veja se eu me importo

########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
1)
#turn off switch and back on
unset bitcoin_drive_import && prune_choice && export bitcoin_drive_import="true"
#turn off switch and back on
unset bitcoin_drive_import && make_bitcoin_conf && export bitcoin_drive_import="true"
break
;;
2)
break
;;
*)
invalid
;;
esac
done
}

function message_move {
set_terminal ; echo -e "
########################################################################################
    
    Se os seus próprios dados Bitcoin tiverem de ser movidos para o diretório de destino 
    na drive, certifique-se de que o fez antes de continuar. Deixe esta janela aberta, 
    abra uma nova janela e faça o trabalho necessário, depois volte e continue.
########################################################################################
"
enter_continue ; jump $enter_cont
}
