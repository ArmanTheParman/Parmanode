function configure_yg {

if [[ $OS == Linux ]] && ! which bc >$dn 2>&1 ; then
    yesorno "Parmanode needs to install a tiny calculator, bc. OK?" && {
    echo "${green}Installing the bc caluclator, necessary for Parmanode to think...$orange"
    sudo apt-get update -y && sudo apt-get install bc
    } || return 1 
fi
########################################################################################

while true ; do #big loop for whole function

while true ; do
announce "Please type in the minimum size, in Satoshis, for the coinjoin you're oferring.
          \r    The default is 1 million sats."
case $enter_cont in
"")
swapstring $jmcfg "minsize =" "minsize = 1000000"
break
;;
*)
[[ $enter_cont -gt 0 ]] || { invalid && continue ; }
swapstring $jmcfg "minsize =" "minsize = 1000000"
break
;;
esac
done

########################################################################################
size_factor = 0.1

while true ; do
announce "For privacy, there is a default variance to your preferred size, set
         \r    at size_factor = 0.1, such that a size of 1M will randomly
         \r    be set tto 0.9M to 1.1M - this is to improve privacy.

         \r    You can leave the default of 0.1, just hit <enter>, or type in a value 
         \r    between 0 and 1."

case $enter_cont in
"")
swapstring $jmcfg "size_factor =" "size_factor = 0.1"
break
;;
*)
[[ $(echo "$enter_cont >= 0" | bc -l) == 1 && $(echo "$enter_cont <= 1" | bc -l) == 1 ]] || { invalid && continue ; }
swapstring $jmcfg "size_factor =" "size_factor = $enter_cont"
break
;;
esac
done

########################################################################################

while true ; do

    yesorno "Would you like to use a relative (percentage) fee offer, or an absolute value?" \
    "r" "relative" "abs" "absolute" \
        && { swapstring $jmcfg "ordertype =" "ordertype = reloffer" ; ordertype=r ; } \
        || { swapstring $jmcfg "ordertype =" "ordertype = absoffer" ; ordertype=a ; }

    if [[ $ordertype == r ]] ; then
        announce "Please type in a value for the relative fee, between 0 and 1.0, eg 0.00002
        \r    would be 0.002% (and 0.5 would ridiculously be 50%)"

        if ! [[ $(echo "$enter_cont > 0" | bc -l) == 1 && $(echo "$enter_cont < 1" | bc -l) ]] ; then
            invalid
            continue
        else
            swapstring $jmcfg "cjfee_r =" "cjfee_r = $enter_cont"
            break
        fi

    elif [[ $ordertype == a ]] ; then
        announce "Plese type in an absolute value in sats you want to receive for oferring coinjoins"
        [[ $enter_cont -ge 0 ]] || invalid && continue
        swapstring $jmcfg "cjfee_a =" "cjfee_a = $enter_cont"
        break
    fi

done

########################################################################################

while true ; do
announce "For privacy, there is a default variance to your preferred fee, set
         \r    at cjfee_factor = 0.1, such that a fee of 1000 will randomly
         \r    be set tto 900 to 1100 - this is to improve privacy.

         \r    You can leave the default of 0.1, just hit <enter>, or type in a value 
         \r    between 0 and 1."

case $enter_cont in
"")
swapstring $jmcfg "cjfee_factor =" "cjfee_factor = 0.1"
break
;;
*)
[[ $(echo "$enter_cont >= 0" | bc -l) == 1 && $(echo "$enter_cont <= 1" | bc -l) == 1 ]] || { invalid && continue ; }
swapstring $jmcfg "cjfee_factor =" "cjfee_factor = $enter_cont"
break
;;
esac
done

yesorno "  \r    The Following are your choices...
$cyan
           \r        $(gsed -n '/ordertype =/p' $jmcfg)
           \r        $(gsed -nE "/cjfee_$ordertype.=/p" $jmcfg)
           \r        $(gsed -n '/cjfee_factor =/p' $jmcfg)
           \r        $(gsed -n '/minsize =/p' $jmcfg)
           \r        $(gsed -n '/size_factor =/p' $jmcfg)" \
    "y" "yes, agree" "n" "no, start over" && return 0 || continue


done #end big loop

}


