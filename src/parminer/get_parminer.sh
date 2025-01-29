function get_parminer {

if [[ ! -e $dp/.parminer_enabled ]] ; then
announce "Sorry, ParMiner is not available freely (not FOSS). It comes with
    ParmanodL laptops ordered from Parman.
   $cyan 
    https://parmanode.com/parmanodl $orange
    "
return 1
fi

if [[ -e $hp/parminer ]] ; then
announce "ParMiner seems to already be downloaded."
return 1
fi

#wont work unless authentication valid
if [[ -e $hp/parminer ]] ; then announce "ParMiner already downloaded" ; return 1 ; fi
if git clone git@github.com:armantheparman/parminer $hp/parminer ; then
    success "ParMiner has been downloaded."
else
    announce "Something went wrong with the Download; Maybe you haven't got approval?"
    return 1
fi
}