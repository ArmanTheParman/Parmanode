function bre_computer_speed {

if ! which dmidecode ; then sudo apt-get install dmidecode ; fi

biosDate=$(sudo dmidecode -t bios | grep Date | cut -d / -f 3)

if [[ -n "$biosDate" && "$biosDate" =~ ^[0-9]{4}$ && $biosDate -lt 2017 ]] ; then 
export fast_computer=false
elif [[ -n "$biosDate" && "$biosDate" =~ ^[0-9]{4}$ && $biosDate -ge 2017 ]] ; then
export fast_computer=true
else

set_terminal
echo -e "
########################################################################################

    Parmanode can configure BTC RPC Explorer to give you a better experience during
    the installation.

    Is your computer probably older than 6 years? $cyan   y  or  n $orange

########################################################################################
"
choose "x"
read choice

if [[ $choice == "y" ]] ; then export fast_computer="yes" ; else export fast_computer="false" ; fi
fi
}