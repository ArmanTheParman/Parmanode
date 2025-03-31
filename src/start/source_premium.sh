function source_premium  {
    [[ -e $pp/parmaweb ]] && for file in $pp/parmaweb/src/*.sh ; do
	    source $file
	done
    [[ -e $dp/.parminer_enabled ]] && [[ -e $pp/parminer ]] && for file in $pp/parminer/src/*.sh ; do
	    source $file
	done
    [[ -e $dp/.datum_enabled ]] && [[ -e $pp/datum ]] && for file in $pp/datum/src/*.sh ; do
	    source $file
	done
    [[ -e $dp/.uddns_enabled ]] && [[ -e $pp/uddns ]] && for file in $pp/uddns/src/*.sh ; do
	    source $file
	done
    [[ -e $dp/.parmascale_enabled ]] && [[ -e $pp/parmascale ]] && for file in $pp/parmascale/src/*.sh ; do
	    source $file
	done
} 