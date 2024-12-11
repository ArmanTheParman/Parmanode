# prune_choice
# set_the_prune
# confirm_set_the_prune

function prune_choice {
if [[ $importdrive == "true" || $bitcoin_drive_import == "true" || $skip_prune_choice == "true" ]] ; then return 0 ; fi
while true ; do
set_terminal
if [[ $btcpayinstallsbitcoin != "true" && $btcdockerchoice != "yes" ]] || [[ $btcpay_combo == "true" ]] ; then
echo -e "
########################################################################################
      $cyan                               
                                     PRUNING
$orange
    O núcleo do Bitcoin precisa de cerca de 1 TB de dados livres, seja numa unidade 
    externa ou interna (aproximadamente 500 Gb para a blockchain atual, mais outros 
    500 Gb para blocos futuros).

    Se o espaço for um problema, pode executar um nó prunado (reduzido), mas tenha em 
    atenção que é pouco provável que tenha uma experiência agradável. Recomendo um nó
    prunado apenas se for a sua única opção, e pode começar de novo com um nó \"não 
    prunado\" assim que for razoavelmente possível. Os nós prunados continuam a 
    descarregar toda a blolckchain, mas depois descartam os dados para poupar espaço. 
    Não poderá utilizar facilmente carteiras com moedas antigas e poderá ser necessário 
    voltar a digitalizar a carteira sem se aperceber - e isso é LENTO.
$cyan
    Você gostaria de rodar o Bitcoin como um nó prunado (geralmente não recomendado)? 
    $orange Isso exigirá cerca de 4 Gb de espaço para o valor mínimo de poda.


                  $red            prune)     Quero prunar

$orange                              s)         Gosto de usar shitcoin

$green                              n)         Não prunar

$orange
########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
else
choice=no
fi

set_terminal

        case $choice in
        q|Q) exit ;; m|M) back2main ;; p|P) return 1 ;;

        prune|Prune|PRUNE)
            set_the_prune           #function definition later in this file. "prune_value" variable gets set.
            break                   #break goes out of loop, and on to writing prune value to parmanode.conf
            ;;

        s|S)
            set_terminal
            dirty_shitcoiner        # LOL
            continue                # continue results in the loop starting over.
            ;;
        
        n|N|No|NO|no)
            export prune_value="0"
            break                   #break goes out of loop, and on to writing prune value to parmanode.conf
            ;;
            
        *)
            invalid
            continue
            ;;

        esac
done

# Write prune choice to config file:
# Menu breaks to here.

#$prune_value set earlier when function called (see function below)

parmanode_conf_remove "prune_value="
parmanode_conf_add "prune_value=$prune_value" 
# Prune choice gets added to bitcoin.conf elsewhere in the code
}

########################################################################################

function set_the_prune {

while true
do
set_terminal
   
echo -e "
########################################################################################

    Introduza um valor de redução$cyan$orange em megabytes (MB) entre 550 e 50000. 
    Sem vírgulas e sem unidades.

########################################################################################
"
read prune_value                    #Prune Value is set here.
set_terminal

                                    # Using regular expression to ensure only a positive 
                                    # integer is entered, and value in range.
                                    # Must pass two if functions to reach the break.

if [[ $prune_value =~ ^[0-9]+$ ]] ; then true ; else echo -e "Invalid entry. Hit$cyan <enter>$orange to try again." ; read ; continue ; fi
    
                                    # Anything below 50000 is ok (my somewhat arbitary cap). 
                                    # Even if zero is selected, it's fine as that turns 
                                    # pruning off. #Values entered below 550 are set at 
                                    # a minimum value of 550 by Bitcoin core.
                                    
if (( $prune_value <= 50000 )) ; then break ; else echo -e "Number not in range. Hit$cyan <enter>$orange to try again." ; read ; continue ; fi
done

                                    # break point reached. $prune_value set and written to 
                                    # parmanode.conf

confirm_set_the_prune
                                    # The logic seems convoluted. Explained:
                                    # "Set_the_prune", STP always calls "confirm_set_the_prune", 
                                    # CSTP, at the end of the function.
                                    # When STP finally breaks from the loop, it hits 
                                    # return 0. CSTP reaching return gets the code back 
                                    # to STP, and allows it to reach it's return 0.
                                    # The code then goes back to "prune_choice", breaks
                                    # from the loop, and gets to writing the $prune_choice
                                    # to parmanode.conf.

                                    # Hopefully this didn't break you
return 0
}

########################################################################################

function confirm_set_the_prune {
    
while true
do
set_terminal
#choice of 3 different menu prints...
if [[ $prune_value == 0 ]] ; then 
break
elif [[ $prune_value -lt 550 ]] ; then
echo -e "
########################################################################################
        
           O valor de redução será definido para o valor mínimo de 550 MB (embora ainda 
           sejam necessários vários gigabytes de armazenamento - abaixo de 10Gb)

 $green                           a)     Aceitar

$red                            c)     Modificar

$cyan                            d)     Recusar prunar
$orange
########################################################################################
"
else
echo -e "
########################################################################################
        
                  O valor de redução será definido como$cyan $prune_value$orange MB

$green                            a)     Aceitar

$red                            c)     Modificar

$cyan                            d)     Recusar prunar
$orange
########################################################################################
"
fi
choose "xq"
read choice
set_terminal
            
            case $choice in
                a|A)
                prune_value="550"
                break
                ;;

                c|C)
                set_the_prune       # can go round and round, nesting until "accept" or 
                                    # "decline" pruning is selected. Then the nesting
                                    # unwinds, each breaking from the loop, and 
                                    # hitting the nested return 0 to move to outer
                                    # layers, finally hitting the last return 0.

                break
                ;;

                d|D)
                prune_value="0" ; echo "Pruning declined." ; enter_continue ; return 0
                break
                ;;

                q|Q|quit|QUIT)
                exit 0
                ;;

                *)
                invalid
                ;;
            esac

done
return 0
}

