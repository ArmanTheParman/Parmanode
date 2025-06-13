function sparrow_fulcrumtor {

if ! which tor >$dn 2>&1 ; then
announce \
"Please install Tor first"
return 1
fi

if ! grep -q "fulcrum-end" $ic ; then
announce \
"Please install Fulcrum first."
return 1
fi


set_terminal
echo "If Sparrow is running, make sure to shut it down before proceeding."
enter_continue
rm $HOME/.sparrow/config
make_sparrow_config "fulcrumtor"
}

function sparrow_electrstor {

if ! which tor >$dn 2>&1 ; then
announce \
"Please install Tor first"
return 1
fi

if ! grep -Eq "electrs-end" $ic && ! grep -Eq "electrsdkr-end" $ic ; then
announce \
"Please install electrs first."
return 1 
fi

set_terminal
make_sparrow_config "electrstor"
}


