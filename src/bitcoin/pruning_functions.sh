# prune_choice
# set_the_prune
# confirm_set_the_prune

function prune_choice {
if [[ $importdrive == true ]] ; then return 0 ; fi
while true
do
set_terminal
echo -e "
########################################################################################
      $cyan                               
                                     PRUNING
$orange
    Bitcoin core needs about 1Tb of free data, either on an external drive or 
    internal drive (500 Gb approx for the current blockchain, plus another 500 Gb for 
    future blocks).

    If space is an issue, you can run a pruned node, but be aware it's unlikely you'll
    have an enjoyable experience. I recommend a pruned node only if it's your only
    option, and you can start over with an \"unpruned\" node as soon as you reasonably 
    can. Pruned nodes still download the entire chain, but then discard the data to 
    save space. You won't be able to use wallets with old coins very easily and 
    rescanning the wallet may be required without you realising - and that is SLOW.
$cyan
    Would you like to run Bitcoin as a pruned node (not recommended generally)? $orange 
    This will require about 4 Gb of space for the minimum prune value.


                  $red            prune)     I want to prune

$orange                              s)         I enjoy shitcoining

$green                              n)         No pruning

$orange
########################################################################################
"
choose "xpmq"

read choice
set_terminal

        case $choice in
        m|M) back2main ;;

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
            
        p|P)
            return 1
            ;;
        q|Q|quit|QUIT)
            exit 0
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

parmanode_conf_remove "prune_value=" 2>&1 
parmanode_conf_add "prune_value=$prune_value" >/dev/null 2>&1
# Prune choice gets added to bitcoin.conf elsewhere in the code
}

########################################################################################

function set_the_prune {

while true
do
set_terminal
   
echo -e "
########################################################################################

    Enter a$cyan pruning value$orange in megabytes (MB) between 550 and 50000. No commas, 
    and no units.

########################################################################################
"
read prune_value                    #Prune Value is set here.
set_terminal

                                    # Using regular expression to ensure only a positive 
                                    # integer is entered, and value in range.
                                    # Must pass two if functions to reach the break.

if [[ $prune_value =~ ^[0-9]+$ ]] ; then true ; else echo "Invalid entry. Hit <enter> to try again." ; read ; continue ; fi
    
                                    # Anything below 50000 is ok (my somewhat arbitary cap). 
                                    # Even if zero is selected, it's fine as that turns 
                                    # pruning off. #Values entered below 550 are set at 
                                    # a minimum value of 550 by Bicoin core.
                                    
if (( $prune_value <= 50000 )) ; then break ; else echo "Number not in range. Hit <enter> to try again." ; read ; continue ; fi
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
if [[ $prune_value == 0 ]] ; then 
echo -e "
########################################################################################
        
                          You have chosen not to prune

 $green                           a)      Accept

$red                            c)      Change

$cyan                            d)      Decline pruning
$orange
########################################################################################
"
elif [[ $prune_value -le 550 ]] ; then
echo -e "
########################################################################################
        
           The prune value will be set to the minimum value of 550 MB (although 
           several gigabytes of storage is still required - under 10Gb)

 $green                           a)     Accept

$red                            c)     Change

$cyan                            d)     Decline pruning
$orange
########################################################################################
"
else
echo -e "
########################################################################################
        
                  The prune value will be set to$cyan $prune_value$orange MB

$green                            a)     Accept

$red                            c)     Change

$cyan                            d)     Decline pruning
$orange
########################################################################################
"
fi
choose "xq"
read choice
set_terminal
            
            case $choice in
                a|A)
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


