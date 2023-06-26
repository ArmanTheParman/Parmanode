function sparrow_remote {
set_terminal
echo "Make sure Sparrow has been shut down before proceeding."
enter_continue

while true ; do
set_terminal
echo "
########################################################################################

    Please paste in the onion address (without the port number at the end).
    Then hit <enter>.
    It should  be a long string of random looking characters, and ening in
    \".onion\".

    You can enter p to go back, or q to quit Parmanode.

########################################################################################

"
read REMOTE_TOR_ADDR
case $REMOTE_TOR_ADDR in
q|Q) exit ;;
p|P) return 1 ;;
"") invalid ;;
*)
set_terminal
echo "
########################################################################################

    Please enter the port number for the remote server, then hit <enter>.

########################################################################################

"
read REMOTE_PORT
rm $HOME/.sparrow/config
make_sparrow_config "fulcrumremote"
;;
esac
done
}