#functions here:
    # enter_continue
    # enter_exit
    # choose
    # invalid
    # previous menu
    # please wait
    # announce
    # errormessage

function enter_continue {
if [[ $installer == parmanodl ]] ; then return 0 ; fi
echo -e " ${yellow}Hit ${cyan}<enter>${yellow} to continue.$orange" ; read
return 0
}

function enter_abort {
#how to use:    enter_abort || return 1
while true ; do
echo -e " ${yellow}Hit ${cyan}<enter>${yellow} to continue, or$red a$yellow to abort." ; read -n1 choice
case $choice in
a) return 1 ;;
"") return 0 ;;
*) invalid ;;
esac
done
}

function enter_return { enter_continue "$@" ; }

function enter_exit {
echo -e " ${yellow}Hit ${cyan}<enter>${yellow} to exit.$orange" ; read
return 0
}

function choose {

if [[ $1 == "xpmq" ]]
then
echo -e " ${yellow}Type your$cyan choice$yellow from above options, or:$cyan (p)$yellow for previous,$red (m)$yellow for main,$green (q)$yellow to quit. 
 Then <enter> : $orange"
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
echo -e " ${yellow}Hit ${cyan}<enter>${yellow} to continue, ${cyan}(p)${yellow} for previous, ${cyan}(q)${yellow} to quit, then <enter>: $orange"
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

function invalid {

set_terminal

echo -e " ${yellow}Invalid choice. Hit ${cyan}<enter>${yellow} before trying again. $orange" ; read
return 0
}

function previous_menu { 

echo -e " ${yellow}Hit ${cyan}<enter>${yellow} to go back to the previous menu.$orange" ; read
return 0
}

function please_wait { 
set_terminal
takes="some time"
if [[ -n $1 ]] ; then takes="$1" ; fi #changes $takes if needed

echo -e "
Please wait, this may take ${takes}...
"
return 0
}

function announce {
set_terminal ; echo -e "
########################################################################################

    $1
    $2

########################################################################################
"
if [[ $2 == enter || $3 == enter ]] ; then return 0 ; else enter_continue ; return 0 ; fi
}

function errormessage {
echo ""
echo " There has been an error. See log files for more info."
enter_continue
}

function ecrm {
echo -e " ${yellow}Hit ${cyan}<enter>${yellow} to continue,$yellow or$green rm <enter>$yellow to return to the menu.$orange" ; read ecrm
return 0
}
