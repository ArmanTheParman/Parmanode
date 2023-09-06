# Functions...
    # Linux_distro
    # which_os
    # check_if_win7
    # IP_address
    # get_linux_version_codename 
    # check_chip

function Linux_distro {
    
if [[ $OS == "Linux" ]] ; then

    if [ -f /etc/debian_version ]; then
    parmanode_conf_add "Linux=Debian"

    elif [ -f /etc/lsb-release ]; then
    parmanode_conf_add "Linux=Ubuntu"

    else
    parmanode_conf_add "Linux=Unknown"

    fi

else
    return 1
fi

return 0
}

function which_os {

chip=$(uname -m)
if [[ "$(uname -s)" == "Darwin" ]]
then
    OS="Mac"
    if [[ -e $HOME/.parmanode/parmanode.conf ]] ; then parmanode_conf_add "OS=${OS}" >/dev/null ; fi
    return 0 
fi

if [[ "$(uname -s)" == "Linux" ]]
then
    OS="Linux"
    if [[ -e $HOME/.parmnode/parmanode.conf ]] ; then parmanode_conf_add "OS=${OS}" >/dev/null ; fi
    return 0
fi

if [[ "$(uname -s)" == "MINGW32_NT" || "$(uname -s)" == "MINGW64_NT" ]]
then
    check_if_win7
    if [[ -e $HOME/.parmanode/parmanode.conf ]] ; then parmanode_conf_add "OS=${OS}" >/dev/null ; fi
    exit 1
fi
exit 1
}

function check_if_win7 {
# will return win7+, linux, or not_win string.
if [[ $(uname -s) == MINGW* ]] ; then
    version=$(wmic os get version | grep -oE "[0-9]+.[0-9]+")
    if (( $(echo "$version >= 6.1" | bc -l) )) ; then
        OS="Win"
    else
        OS="Win_old"
    fi
else
    OS="Not_Win"
fi
return 0
}

function IP_address {
#IP variable in run_parmanode.sh
echo "
########################################################################################


    Your computer's IP address is:                                $IP



    Your computer's "self" IP address should be:                  127.0.0.1



    For reference, every computer's default self IP address is    127.0.0.1 
                                                            or    localhost


########################################################################################
"
enter_continue
return 0
}

function get_linux_version_codename {
. /etc/os-release && VC=$VERSION_CODENAME
. $HOME/.parmanode/parmanode.conf #(fix ID variable)



# Linux Mint has Ubunta equivalents for this purpose
if [[ $VC == "vera" ]] ; then VCequivalent="jammy" ; parmanode_conf_add "VCequivalent=$VCequivalent" 
elif [[ $VC == "vanessa" ]] ; then VCequivalent="jammy" ; parmanode_conf_add "VCequivalent=$VCequivalent"  
elif [[ $VC == "una" ]] ; then VCequivalent="focal" ; parmanode_conf_add "VCequivalent=$VCequivalent" 
elif [[ $VC == "uma" ]] ; then VCequivalent="focal" ; parmanode_conf_add "VCequivalent=$VCequivalent" 

elif [[ $VC == "ulyssa" ]] ; then VCequivalent="focal" ; parmanode_conf_add "VCequivalent=$VCequivalent"  
elif [[ $VC == "ulyana" ]] ; then VCequivalent="focal" ; parmanode_conf_add "VCequivalent=$VCequivalent" 
elif [[ $VC == "tricia" ]] ; then VCequivalent="bionic" ; parmanode_conf_add "VCequivalent=$VCequivalent"
elif [[ $VC == "tina" ]] ; then VCequivalent="bionic" ; parmanode_conf_add "VCequivalent=$VCequivalent"  
elif [[ $VC == "tessa" ]] ; then VCequivalent="bionic" ; parmanode_conf_add "VCequivalent=$VCequivalent" 
elif [[ $VC == "tara" ]] ; then VCequivalent="bionic" ; parmanode_conf_add "VCequivalent=$VCequivalent" 
elif [[ $VC == "elsie" ]] ; then VCequivalent="bullseye" ; parmanode_conf_add "VCequivalent=$VCequivalent" 
#new 

elif [[ $VC == "victoria" ]] ; then VCequivalent="jammy" ; parmanode_conf_add "VCequivalent=$VCequivalent"  

else
VCequivalent=$VC
fi
parmanode_conf_add "VCequivalent=$VCequivalent"

}

function check_chip {

export chip="$(uname -m)" >/dev/null 2>&1

parmanode_conf_add "chip=$chip"

}