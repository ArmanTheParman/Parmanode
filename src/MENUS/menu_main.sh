function menu_main {
while true ; do
set_terminal

source $pn/version.conf >$dn
source $hm >$dn 2>&1 #hide messages
if [[ $vPatch -gt 9 ]] ; then space="" ; else space=" " ; fi #in case version number is high, adjust menu border

branch="$(git status | head -n1 | awk '{print $3}')"
if [[ $branch != master && -n $branch ]] ; then
output_branch="${pink}AVISO: Está no branch$branch.                        $orange"
else
output_branch="   $space                                                         $orange#"
fi

set_terminal_custom 51
if [[ $debug = 1 ]] ; then
debugstatus="#${red}    O modo de depuração está ativado$orange                                                                  #"
else
debugstatus="#                                                                                      #"
fi

# if statements in the menu printout makes the menu dynamic, ie changes according to the
# tests performed. Variables are set to assist logic in the menu choice execution part
# of the code at the bottom.
echo -en "$orange
########################################################################################
#                                                                                      #
#    P A R M A N O D E     ${bright_blue}Menu principal$orange                                                   #
#                                                                                      #
#    Version:$bright_blue $version     $output_branch
"
echo -e "$debugstatus
########################################################################################
#                                                                                      #
#                                                                                      #
#$green    (add)    $orange           Adicionar mais programas                                            #
#                                                                                      #
#$cyan    (u)            $orange      Utilizar programas instalados                                       #
#                                                                                      #
#$red    (remove)     $orange         Remover/desinstalar programas                                    #
#                                                                                      #
#$cyan    (o)$orange                  Visão geral/estatuto dos programas                                  #
#                                                                                      #
#$cyan    (ns)$orange                 ${yellow}${blinkon}Atalhos de navegação (novo)$blinkoff$orange                                   #
#                                                                                      #
#--------------------------------------------------------------------------------------#
#                                                                                      #
#$cyan    (t)        $orange          Ferramentas                                                  #
#                                                                                      #
#$cyan    (s)              $orange    Definições/Cores                                             #
#                                                                                      #
#$cyan    (mm)$orange                 Mentoria com Parman - Info                                   #
#                                                                                      #
#$cyan    (e)       $orange           Educação                                                     #
#                                                                                      #
#$cyan    (d)             $orange     Donativo                                                     #
#                                                                                      #
#$cyan    (log) $orange               Ver registos e ficheiros de configuração                     #
#                                                                                      #
#$cyan    (update)  $orange           Atualização Parmanode                                        #
#                                                                                      #
#$red    (uninstall)     $orange      Desinstalar a Parmanode                                      #
#                                                                                      #
#$cyan    (ap)$orange                 Sobre Parmanode                                              #
#                                                                                      #
#                                                                                      #
########################################################################################

 Escreva a sua escolha$cyan$orange sem os parênteses e prima$green <enter>$orange 
 Ou, para sair, carregue em$green <control>-c$orange, ou escreva$cyan q$orange e depois$green <enter>$orange.
"
if [[ ! $announcements == off ]] ; then
echo -e "
 Sugestão: combine u com as opções de menu seguintes. Por exemplo, tente ub para o menu bitcoin

$blinkon$red                   AVISO!!! NÃO TEM BITCOIN SUFICIENTE $orange$blinkoff"
fi

read choice #whatever the user chooses, it gets put into the choice variable used below.
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in #the variable choice is tested through each of the case-choices below.
# these end in a closing bracket, have some code, and end with a ;;
# once there is a match, the case block is exited (after the esac point below). Then
# it repeats because case is inside a while loop.

q|Q) exit ;;
ns) navigation_shortcuts ;;
aa)
if [[ $announcements == off ]] ; then
sudo gsed -i "/announcements=/d" $hm 
echo "announcements=on" | tee -a $hm 
else
sudo gsed -i "/announcements=/d" $hm 
echo "announcements=off" | tee -a $hm
fi
;;
o|O)
menu_overview 
;;

add|Add|ADD)
    menu_add
    ;;
use|USE|Use|u|U)
    menu_use
    ;;
remove|REMOVE)
    menu_remove ;;
l|L) 
    menu_log_config ;;
mm|MM)
     mentorship
     ;;
e|E)
    menu_education ;;
t|T)
    menu_tools ;;
s|S)
    menu_settings ;;
d|D)
    sned_sats ;;
un|uninstall|UNINSTALL)
uninstall_parmanode
;;
up|update|UPDATE|Update)
    update_parmanode || continue
    if [[ $main_loop != 0 ]] ; then
    set_terminal ; 
    announce "É necessário sair e recarregar o Parmanode para utilizar a nova versão do Parmanode."
    continue
    fi
    # The user has been alerted to needing to restart Parmanode for the changes to take effect.
    # Setting exit_loop to false allows the program to continue without forcing an exit.
    if [[ $exit_loop == "false" ]] ; then return 0 ;fi
;;
ap|AP|Ap|aP)
    about ;;

uany) menu_use any ;; 
ub) menu_use b ;; 
ubb) menu_use bb ;;
ubre) menu_use bre ;; 
ubtcp) menu_use btcp ;;
ue) menu_use e ;;
uers) menu_use ers ;;
uf) menu_use f ;;
ul) menu_use l ;; 
ulnb) menu_use lnb ;;
ut) menu_use t ;;
us) menu_use s ;;
ur) menu_use r ;;
uts) menu_use ts ;;
ubtcpt) menu_use btcpt ;; 
us) menu_use s ;;
utrz) menu_use trz ;;
ull) menu_use ll ;;
ups) menu_use ps ;;
upbx) menu_use pbx ;;
upih) menu_use pih ;;
uqbit) menu_use qbit ;;
umem) menu_use mem ;;
uersd) menu_use ersd ;;
upool) menu_use pool ;;
uex) menu_use ex ;;
uth) menu_use th ;;
unr) menu_use nr ;;
ulitd) menu_use litd ;;
ult) menu_use lt ;;
unext) menu_use next ;;


ul|UL|Ul)
clear ; please_wait
menu_lnd
;;

debugon) 
export debug=1 ;;
debugoff) 
export debug=0 ;;

*)
invalid ; clear ;;

esac ; done ; return 0
}

function navigation_shortcuts {
set_terminal_custom 44 ; echo -e "
########################################################################################
$red$blinkon
                               B O A S  N O T I C I A S  ! ! $blinkoff$orange

########################################################################################


    Tornei muito mais fácil a deslocação. Claro que ainda podes usar a forma antiga, 
    mas agora podes saltar para onde queres ir se te lembrares dos comandos.

    Por exemplo, para bitcoin, pode escrever:
    $green
                        mb$orange    or$green   mbitcoin$orange

    para electrs:
                $green
                        mers$orange  or$green    melectrs$orange

    Para ver todos os atalhos possíveis, dê uma vista de olhos ao código (digite$cyan ' code'$orange) e 
    $cyan<enter>$orange a partir daqui... não, na verdade, quase a partir de qualquer lugar - bom, não é?

    Por exemplo, onde se vê...
$cyan
                ubitcoin|ub|mbitcoin|mb)
                    if grep -q "bitcoin-end" \$ic ; then
                        menu_bitcoin
                        invalid_flag=set
                    else return 1
                    fi
                ;;
$orange
    ... isso significa que se você digitar 'mbitcoin' ou 'ub' etc, então o código abaixo, 
    até o ;; será executado. Ele diz que se o texto 'bitcoin-end' existir no arquivo ic 
    (abreviação de installed.conf), então menu_bitcoin será executado, seguido pela 
    definição de uma bandeira, que é apenas um sinal para uma parte diferente do código 
    saber para onde ir em seguida. A parte 'else' significa sair se bitcoin-end não existir. 

########################################################################################
"
enter_continue ; jump $enter_cont 
set_terminal ; echo -e "
########################################################################################

    MAS ESPERA! Há mais.

    Pode saltar diretamente para o menu da sua escolha a partir da linha de comando. 
    Por exemplo...$cyan

    rp mb$orange ... para o levar diretamente para o menu Bitcoin.

    ou
$cyan
    rp mbtcp$orange ... para o levar diretamente para o menu BTCPay.
$yellow

    Podem surgir os habituais ecrãs do pré-menu principal, que podem 
    ser permanentemente eliminados da forma habitual, se pretender mais velocidade.
$orange
########################################################################################
"
enter_continue ; jump $enter_cont
return 0
}


#    For now, you can jump to any installed app's menu. Later, installing and
#    uninstalling and other menu jumps will become available.
