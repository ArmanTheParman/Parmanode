function choose_bitcoin_version_mac {
export knotsversion="27.1"
while true ; do
set_terminal  ; echo -e "
########################################################################################

    $green
    Você tem opções para instalar o Bitcoin com o Parmanode... $orange


$cyan    1)$orange    Versão Bitcoin QT $version

$cyan    2)$bright_blue    Versão Bitcoin Knots $knotsversion $orange

$cyan    3)$red    Bitcoin em Docker (com BTCPay)$orange 

            Esta é uma nova adição à Parmanode: Você pode optar por instalar o Bitcoin 
            E o BTCPay Server juntos num container Docker. Terás todas as mesmas opções 
            de menu no Parmanode, mas não terás o pop-up da GUI do Bitcoin-QT. 
            O Docker precisa estar rodando para que o Bitcoin esteja rodando.

$green

    O que é que vai ser?

$cyan                   1)$orange     Bitcoin QT

$cyan                   2)$bright_blue     Todos os miúdos fixes estão a usar o Knots

$cyan                   3)$red     Bitcoin E BTCPay em Docker

$orange
########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

1)
export btcdockerchoice=no
export bitcoin_compile="false"
break
;;
2)
parmanode_conf_add "bitcoin_choice=knots"
export knotsbitcoin="true" ; export version="Knots" ; export bitcoin_compile="false" 
export btcdockerchoice=no
break
;;
3)
export btcdockerchoice=yes
export bitcoin_compile="false"
break
;;
*)
invalid
;;
esac
done


}
