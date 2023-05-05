function make_lnd_directories {
if [[ -d $HOME/.lnd ]] ; then
set_terminal
echo "The .lnd directory exists. It will be deleted. If that's ok, "
echo "Hit <enter> to proceed. Otherwise, Hit <control>-C to abort."
enter_continue
fi

rm -rf $HOME/.lnd && mkdir $HOME/.lnd >/dev/null 2>&1
rm -rf $HOME/parmanode/lnd && mkdir $HOME/parmanode/lnd >/dev/null 2>&1
}


