function get_parminer {

if [[ $preconfigure_parmadrive == "true" ]] ; then
    if grep -q "parminer-end" $ic ; then return 0 ; fi
fi


if [[ ! -e $dp/.parminer_enabled && ! -e $dp/.enable_parminer ]] ; then
announce_blue "Sorry, ParMiner is not available freely (not FOSS). It comes with
    ParmanodL laptops ordered from Parman.
   $cyan 
    https://parmanode.com/parmanodl $orange
    "
return 1
fi

if [[ -e $pp/parminer ]] ; then
announce_blue "ParMiner seems to already be downloaded."
return 1
fi

#wont work unless authentication valid
if [[ -e $pp/parminer ]] ; then announce_blue "ParMiner already downloaded" ; return 1 ; fi

if git clone git@github-parminer:armantheparman/parminer $pp/parminer ; then
    installed_config_add "parminer-end"
    source_premium
    success_blue "ParMiner Menu has been downloaded."
else
    announce_blue "Something went wrong with the Download; Maybe you haven't got approval?"
    return 1
fi
}