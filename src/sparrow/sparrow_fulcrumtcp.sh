function sparrow_fulcrumtcp {
set_terminal
echo "Make sure Sparrow has been shut down before proceeding."
enter_continue
rm $HOME/.sparrow/config
make_sparrow_config "fulcrumtcp"
}