function choose_bitcoin_version {
if [[ $version == self ]] ; then return 0 ; fi
if [[ $OS == Mac ]] ; then return 0 ; fi

if [[ $btcpayinstallsbitcoin == "true" || $btcdockerchoice == "yes" ]] ; then
parmanode_conf_add "bitcoin_choice=precompiled"
export bitcoin_compile="false"
return 0
fi


while true ; do
#default version set at the beginning of instll_bitcoin()
set_terminal ; echo -e "
########################################################################################
$cyan
    EXISTEM VÁRIAS MANEIRAS DE INSTALAR O BITCOIN COM O PARMANODE. POR FAVOR ESCOLHA...
$orange
########################################################################################
$green
       0)  v$version - Descarregar e verificar versões 'confiáveis'
$red
       1)  Versão personalizada (à sua escolha) - Descarregar e verificar versões ´confiáveis'

       2)  Compilação guiada versão personalizada (à escolha)
$green
       3)  Compilação guiada v$version
$bright_blue
       4)  Compilação guiadav$version (correção FILTER-ORDINALS, por Luke Dashjr)

       5) Compilação guiada$yellow Bitcoin Knots$bright_blue ( versão de Luke Dashjr do Bitcoin Core) - 
           sincroniza mais rapidamente; correcções de erros em falta no Core; e 
           opções/ferramentas para utilizadores avançados.
$red
       6)  Compilação guiada da atualização mais recente do Github, ou seja, 
           pré-lançamento (apenas para ensaios)
$orange
 INFO  7)  Leia como compilar você mesmo, e importar a instalação para a Parmanode.
           Pode voltar a este menu depois de o ter selecionado.

       8)  IMPORTAR binários que você mesmo compilou (ou baixou anteriormente sem a 
           ajuda do processo de instalação da Parmanode). 'Binários' refere-se aos 
           ficheiros executáveis, por exemplo bitcoind e bitcoin-qt, não à blockchain.
$orange
########################################################################################   
"
choose "xpmq" 
unset bitcoin_compile ordinals_patch knotsbitcoin byo_bitcoin
read choice
jump $choice || { invalid ; continue ; } ; set_terminal

case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;
0|27|"")
parmanode_conf_add "bitcoin_choice=precompiled"
export bitcoin_compile="false" ; break ;;
1) 
parmanode_conf_add "bitcoin_choice=precompiled"
select_custom_version || return 1
export bitcoin_compile="false" ; break ;;
2) 
parmanode_conf_add "bitcoin_choice=compiled"
select_custom_version || return 1
export bitcoin_compile="true" ; break ;;
3) 
parmanode_conf_add "bitcoin_choice=compiled"
export bitcoin_compile="true" ; break ;;
4)
parmanode_conf_add "bitcoin_choice=compiled"
export bitcoin_compile="true" ; export ordinals_patch="true" ; break ;;
5)
parmanode_conf_add "bitcoin_choice=knots"
export bitcoin_compile="true"
export knotsbitcoin="true" ; export version="27.x-knots" ; break ;;
6)
parmanode_conf_add "bitcoin_choice=compiled"
export bitcoin_compile="true" ; export version="master" ; break ;;
7)
bitcoin_compile_instructions
return 0
;;

8)
set_terminal ; echo -e "
########################################################################################
  Certifique-se de que os ficheiros binários Bitcoin foram colocados no diretório 
  /usr/local/bin/
########################################################################################
"
enter_continue  ; jump $enter_cont
export bitcoin_compile="false"
export version="self"
if ! which bitcoind >$dn ; then
set_terminal ; echo -e "
########################################################################################

    Parmanode não conseguiu detetar bitcoind em$cyan /usr/local/bin$orange. 
    Abortando.

########################################################################################
"
enter_continue ; jump $enter_cont
return 1
else
return 0
fi
;;

*) 
invalid ;;
esac
done

if [[ $bitcoin_compile != "false" ]] ; then
# $hp/bitcoin directory made earlier for downloading compiled bitcoin. Can delete.
sudo rm -rf $hp/bitcoin >$dn 2>&1
fi

}

function select_custom_version {

while true ; do 
set_terminal ; echo -e "
########################################################################################
    
    Introduza um número de versão

    Eg. ${cyan}25.0$orange

    Por favor, note que o script de compilação automática da Parmanode não funciona com 
    todas as versões, especialmente as primeiras. Não custa nada tentar. 
    Talvez venha a trabalhar nisto no futuro.

########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; }
case $choice in
p|P) return 1 ;; q|Q) exit ;; m|M) back2main ;;
*)
#remove the v if entered
choice=$(echo $choice | gsed 's/^v//')

    if ! echo $choice | grep -Eq "^[0-9]+\.[0-9]+" ; then
    yesorno "What you entered seems to not be valid. Proceed anyway?" || continue
    fi
    if echo $choice | grep -Eq "^0\.1.*" ; then
    announce "Isto não funciona com versões inferiores a 0.2.0 compiladas no Windows."
    continue
    fi
    if echo $choice | grep -Eq "^0\.(1|2)$" ; then
    announce "O número da versão não está no formato correto."
    continue
    fi


export version=$choice
break
;;
esac
done

}
