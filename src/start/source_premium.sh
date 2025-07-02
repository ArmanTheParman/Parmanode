function source_premium {
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
    [[ -e $dp/.parmasync_enabled ]] && [[ -e $pp/parmasync ]] && for file in $pp/parmasync/src/*.sh ; do
	    source $file
	done
    [[ -e $dp/.parmatwin_enabled ]] && [[ -e $pp/parmatwin ]] && for file in $pp/parmatwin/src/*.sh ; do
	    source $file
	done
    [[ -e $dp/.parmanas_enabled ]] && [[ -e $pp/parmanas ]] && for file in $pp/parmanas/src/*.sh ; do
	    source $file
	done
    [[ -e $dp/.parmasql_enabled ]] && [[ -e $pp/parmasql ]] && for file in $pp/parmasql/src/*.sh ; do
	    source $file
	done
    [[ -e $dp/.parmanpremium_enabled ]] && [[ -e $pp/parmanpremium ]] && for file in $pp/parmanpremium/src/*.sh ; do
	    source $file
	done
#custom
    if ! test -f $dp/donotsourceparmadrive ; then
		[[ -e $pp/parmadrive ]] && for file in $pp/parmadrive/src/*.sh ; do
			source $file
		done
	fi
} 