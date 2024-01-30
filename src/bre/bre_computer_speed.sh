function bre_computer_speed {

if [[ $OS == Mac ]] ; then
    bre_computer_speed_message
    read choice
    if [[ $choice == "y" ]] ; then export fast_computer="yes" ; else export fast_computer="false" ; fi
    return 0
fi


#### For Linux ####
if ! which dmidecode >/dev/null 2>&1 ; then sudo apt-get install dmidecode ; fi

biosDate=$(sudo dmidecode -t bios | grep Date | cut -d / -f 3)

if [[ -n "$biosDate" && "$biosDate" =~ ^[0-9]{4}$ && $biosDate -lt 2017 ]] ; then 
export fast_computer=false
elif [[ -n "$biosDate" && "$biosDate" =~ ^[0-9]{4}$ && $biosDate -ge 2017 ]] ; then
export fast_computer=true
else
    if [[ $computer_type == Pi ]] ; then export fast_computer="yes" ; return ; fi
    bre_computer_speed_message
    read choice
    if [[ $choice == "y" ]] ; then export fast_computer="yes" ; else export fast_computer="false" ; fi
fi
}

function bre_computer_speed_message {
set_terminal
echo -e "
########################################################################################

    Parmanode can configure BTC RPC Explorer to give you a better experience during
    the installation.

    Is your computer probably older than 6 years? $cyan   y  or  n $orange

########################################################################################
"
choose "x"
}