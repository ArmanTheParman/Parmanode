function enter_continue {
if [[ $1 -gt 0 ]] 2>$dn ; then 
    echo -e "${yellow}Hit ${cyan}<enter>${yellow} to continue.$orange\n"  
    read -r -t $1 enter_cont || enter_cont="" 
else
echo -en "$1\n"
unset enter_cont
if [[ $installer == parmanodl ]] ; then return 0 ; fi

[[ $2 != silent ]] && echo -e "${yellow}Hit ${cyan}<enter>${yellow} to continue.$orange\n"  

if [[ $silentecho == "true" ]] ; then
read -r -s enter_cont
else
    if [[ $2 -gt 0 ]] 2>$dn ; then read -r -t $2 enter_cont ; else read -r enter_cont ; fi
fi
fi #end -gt 0

export enter_cont

case $enter_cont in
q) exit ;; tmux) tmux ;; x)  set +x ;; debugon) export debug=1 fi ;; debugoff) export debug=0 ;;
d)
    if [[ $debug == 1 ]] ; then export debug=0 ; fi
    if [[ $debug == 0 ]] ; then export debug=1 ; fi
    ;;
esac
return 0
}

function enter_or_quit {
echo -e " ${yellow}Hit ${cyan}<enter>${yellow} to continue.$yellow, or $red q$yellow to quit.$orange" 
read -r enter_cont ; export enter_cont
if [[ $enter_cont == debugon ]] ; then export debug=1 ; fi
if [[ $enter_cont == debugoff ]] ; then export debug=0 ; fi
if [[ $enter_cont == q ]] ; then exit ; fi
return 0

}

function enter_abort {
echo -e " ${yellow}Hit ${cyan}<enter>${yellow} to continue, or$red a$yellow to abort.$orange" 
#use this in a loop...
#read -r choice ; case $choice in a|A) return 1 ;; "") break ;; esac ; done
return 0
}

function enter_return { enter_continue "$@" ; }

function choose {

if [[ $1 == "xmq" ]]
then
echo -e " ${yellow}Type your$cyan choice$yellow from above options, or:$red (m)$yellow for main,$green (q)$yellow to quit. 
 Then <enter> : $orange"
return 0
fi

if [[ $1 == "xpmq" ]]
then
echo -e " ${yellow}Type your$cyan choice$yellow from above options, or:$cyan (p)$yellow for previous,$red (m)$yellow for main,$green (q)$yellow to quit. 
 Then <enter> : $orange"
return 0
fi

if [[ $1 == "emq" ]]
then
echo -e " ${yellow}Hit$cyan enter$yellow to continue, or:$red (m)$yellow for main,$green (q)$yellow to quit.$orange" 
return 0
fi

if [[ $1 == "epmq" ]]
then
echo -e " ${yellow}Hit$cyan enter$yellow to continue, or:$cyan (p)$yellow for previous,$red (m)$yellow for main,$green (q)$yellow to quit.$orange" 
return 0
fi

if [[ $1 == "xpq" ]]
then
echo -e " ${yellow}Type your$cyan choice$yellow from above options, or:$cyan (p)$yellow for previous,$green (q)$yellow to quit. 
 Then <enter> : $orange"
return 0
fi

if [[ $1 == "xq" ]]
then
echo -e " ${yellow}Type your ${cyan}choice${yellow}, or$cyan (q)$yellow to quit, then <enter>: $orange"
return 0
fi

if [[ $1 == "eq" ]]
then
echo -e " ${yellow}Hit ${cyan}<enter>${yellow}, to continue, or ${cyan}(q)${yellow} to quit, then <enter>: $orange"
return 0
fi

if [[ $1 == "x" ]]
then
echo -e " ${yellow}Type your ${cyan}choice${yellow}, then <enter>: $orange"
return 0
fi

if [[ $1 == "epq" ]]
then
if [[ -z $2 ]] ; then CONTINUE="continue" ; fi
echo -e " ${yellow}Hit ${cyan}<enter>${yellow} to $2, ${cyan}(p)${yellow} for previous, ${cyan}(q)${yellow} to quit, then <enter>: $orange"
# while true ; do 
# case $choice in q|Q|QUIT|Quit) exit 0 ;; p|P) return 1 ;; "") break ;; *) invalid ;; esac ; done
return 0
fi

if [[ $1 == "esq" ]]
then
echo -e " ${yellow}Hit ${cyan}<enter>${yellow} to continue, ${cyan}(s)${yellow} to skip, ${cyan}(q)${yellow} to quit, then <enter>: $orange"
# while true ; do 
# case $choice in q|Q|QUIT|Quit) exit 0 ;; p|P) return 1 ;; "") break ;; *) invalid ;; esac ; done
return 0
fi

if [[ $1 == "qc" ]]
then
echo -e " ${yellow}Hit ${cyan}(q)${yellow} then <enter> to quit, ${cyan}anything${yellow} else to continue.$orange"
return 0
fi

return 1 
}

function invalid_blue {
if [[ -n $invalid_flag ]] ; then unset invalid_flag ; return 1 ; fi 

set_terminal
echo -e " ${blue}Invalid choice. Hit ${orange}<enter>${blue} before trying again. $blue" ; read -r invalid
if [[ $invalid == 'q' || $invalid == "exit" ]] ; then exit ; fi
return 0
}

function invalid {
if [[ -n $invalid_flag ]] ; then unset invalid_flag ; return 1 ; fi 

set_terminal
echo -e " ${yellow}Invalid choice. Hit ${cyan}<enter>${yellow} before trying again. $orange" ; read -r invalid
if [[ $invalid == 'q' || $invalid == "exit" ]] ; then exit ; fi
return 0
}

function please_wait_no_clear { 
echo -e "
Please wait, this may take some time ...
"
return 0
}

function please_wait { 

if ! [[ $1 == "noclear" ]] ; then 
set_terminal
fi

takes="some time"
if [[ -n $1 ]] ; then takes="$1" ; fi #changes $takes if needed

echo -e "
Please wait, this may take ${takes}...
"
return 0
}

function announce {
set_terminal 42 ; echo -e "
########################################################################################

    $1"
if [[ -z $2 ]] ; then
echo -e "
########################################################################################
"
else
echo -e "    $2

########################################################################################
"
fi
if [[ $2 == enter || $3 == enter ]] ; then return 0 ; else enter_continue ; return 0 ; fi
}
function announce_blue {
set_terminal 42 ; echo -e "$blue
########################################################################################

    $1"
if [[ -z $2 ]] ; then
echo -e "$blue
########################################################################################
$orange"
else
echo -e "$blue    $2

########################################################################################
$orange"
fi
if [[ $2 == enter || $3 == enter ]] ; then return 0 ; else enter_continue ; return 0 ; fi
}

function short_announce {
# $1 is the message $2 is the time before continuing automatically
set_terminal ; echo -e "
########################################################################################

    $1

########################################################################################
"
enter_continue $2
}