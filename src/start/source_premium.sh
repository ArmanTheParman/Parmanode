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
    [[ -e $dp/.parmasync_enabled ]] && [[ -e $pp/parmasync ]] && for file in $pp/parmasync/src/*.sh ; do
	    source $file
	done
#custom
    if ! test -f $dp/donotsourceparmadrive ; then
		[[ -e $pp/parmadrive ]] && for file in $pp/parmadrive/src/*.sh ; do
		    echo "Sourcing $file"
			read
			source $file
		done
	fi
} 