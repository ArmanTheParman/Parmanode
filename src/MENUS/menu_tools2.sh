function menu_tools2 {

while true ; do
set_terminal_high
echo -en "
########################################################################################$cyan
                                   FERRAMENTAS - PAGINA 2  $orange
########################################################################################


$cyan              (bd)$orange        Instalar o Bitcoin em um contêiner Docker em execução

$cyan              (as)$orange        Guia do túnel de proxy reverso AutoSSH

$cyan              (curl)$orange      Testar o comando curl/rpc do bitcoin (para resolução de problemas)

$cyan              (de)$orange        Encriptação de unidades - informações

$cyan              (fs)$orange        Libertar algum espaço

$cyan              (gc)$orange        Teste de chamada RPC para LND (grpcurl)

$cyan              (rest)$orange      Teste do protocolo REST ao LND (apenas informação)

$cyan              (rf)$orange        Atualizar o diretório de scripts Parmanode             

$cyan              (sr)$orange        Relatório do sistema (para obter ajuda na resolução de problemas)

$cyan              (ps)$orange        Ajustar a poupança de energia do SSD

$orange
########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;;  m|M) back2main ;; p|P) return 0 ;;

bd)
install_bitcoin_docker
return 0
;;

curl)
bitcoin_curl
return 0
;;

gc)
grpccurl_call
;;

rf)
parmanode_refresh
return 0
;;

sr)
system_report
return 0
;;

fs)
free_up_space
;;

rest)
rest_protocol_test
;;

as)
autossh_setup
;;

de)
drive_encryption
;;

ps)
adjust_ssd_power_saving
;;

*)
invalid 
;;
esac
done
return 0
}

