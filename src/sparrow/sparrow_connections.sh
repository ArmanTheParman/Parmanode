function sparrow_fulcrumtor {

if ! which tor >/dev/null 2>&1 >/dev/null ; then
announce \
"Please install Tor first"
return 1
fi

if ! grep -q "fulcrum-end" < $HOME/.parmanode/installed.conf ; then
announce \
"Please install Fulcrum first."
return 1
fi

if ! grep -q "fulcrum_tor" < $HOME/.parmanode/parmanode.conf ; then
announce \
"Please enable TOR in Fulcrum menu first."
return 1 
fi


set_terminal
echo "Make sure Sparrow has been shut down before proceeding."
enter_continue
rm $HOME/.sparrow/config
make_sparrow_config "fulcrumtor"
}

function sparrow_electrstor {

if ! which tor >/dev/null 2>&1 ; then
announce \
"Please install Tor first"
return 1
fi

if ! grep -q "electrs-end" < $HOME/.parmanode/installed.conf ; then
announce \
"Please install electrs first."
return 1 
fi

if ! grep -q "electrs_tor" < $HOME/.parmanode/parmanode.conf ; then
announce \
"Please enable TOR in electrs menu first."
return 1
fi


set_terminal
echo "Make sure Sparrow has been shut down before proceeding."
enter_continue
rm $HOME/.sparrow/config
make_sparrow_config "electrstor"
}

function sparrow_fulcrumtcp {
set_terminal
echo "Make sure Sparrow has been shut down before proceeding."
enter_continue
rm $HOME/.sparrow/config
make_sparrow_config "fulcrumtcp"
}

function sparrow_electrs {

set_terminal
echo "Make sure Sparrow has been shut down before proceeding."
enter_continue
rm $HOME/.sparrow/config
make_sparrow_config "electrstcp"
}
function sparrow_fulcrumssl {
set_terminal
echo "Make sure Sparrow has been shut down before proceeding."
enter_continue
rm $HOME/.sparrow/config
make_sparrow_config "fulcrumssl"
}

function sparrow_core {
set_terminal
echo "Make sure Sparrow has been shut down before proceeding."
enter_continue
rm $HOME/.sparrow/config
make_sparrow_config
}
