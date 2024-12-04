function jmvenv {

if [[ $1 == "activate" ]] ; then
$hp/joinmarket/jmvenv/bin/activate
return 0
fi

if [[ $1 == "deactivate" ]] ; then
deactivate >$dn 2>&1
return 0
fi

}