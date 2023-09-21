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
echo -e "${yellow}Hit <enter> to continue.$orange" ; read
return 0
}

function enter_exit {
echo -e "${yellow}Hit <enter> to exit.$orange" ; read
return 0
}

function choose {

if [[ $1 == "xpq" ]]
then
echo -e "${yellow}Type your choice, or (p) for previous, (q) to quit, then <enter>: $orange"
return 0
fi

if [[ $1 == "xq" ]]
then
echo -e "${yellow}Type your choice, or (q) to quit, then <enter>: $orange"
return 0
fi

if [[ $1 == "x" ]]
then
echo -e "${yellow}Type your choice, then <enter>: $orange"
return 0
fi

if [[ $1 == "epq" ]]
then
echo -e "${yellow}Hit <enter> to continue, (p) for previous, (q) to quit, then <enter>: $orange"
# while true ; do 
# case $choice in q|Q|QUIT|Quit) exit 0 ;; p|P) return 1 ;; "") break ;; *) invalid ;; esac ; done
return 0
fi

if [[ $1 == "esq" ]]
then
echo -e "${yellow}Hit <enter> to continue, (s) to skip, (q) to quit, then <enter>: $orange"
# while true ; do 
# case $choice in q|Q|QUIT|Quit) exit 0 ;; p|P) return 1 ;; "") break ;; *) invalid ;; esac ; done
return 0
fi

if [[ $1 == "qc" ]]
then
echo -e "${yellow}Hit (q) then <enter> to quit, anything else to continue.$orange"
return 0
fi

return 1 
}

function invalid {

set_terminal

echo -e "${yellow}Invalid choice. Hit <enter> before trying again. $orange" ; read
return 0
}

function previous_menu { 

echo -e "${yellow}Hit <enter> to go back to the previous menu.$orange" ; read
return 0
}

function please_wait { 
set_terminal
echo -e "
Please wait, this may take some time...
"
return 0
}

function announce {
set_terminal ; echo "
########################################################################################

    $1
    $2

########################################################################################
"
if [[ $3 == enter ]] ; then return 0 ; else enter_continue ; return 0 ; fi
}

function errormessage {
echo ""
echo "There has been an error. See log files for more info."
enter_continue
}
