function sparrow_fulcrumtor {

if ! which tor >/dev/null ; then
announce \
"Please install Tor first"
return 1
fi

if ! grep -q "fulcrum-end" < $HOME/.parmanode/installed.conf ; then
announce \
"Please install Fulcrum first."
return 1
fi


set_terminal
echo "Make sure Sparrow has been shut down before proceeding."
enter_continue
rm $HOME/.sparrow/config
make_sparrow_config "fulcrumtor"
}