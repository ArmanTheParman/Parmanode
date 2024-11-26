function sparrow_remote {
set_terminal
echo "If Sparrow is running, make sure to shut down before proceeding."
enter_continue

while true ; do
set_terminal
echo -e "
########################################################################################

    Please paste in the onion address (without the port number at the end).
    Then hit$cyan<enter>$orange.
    It should be a long string of random looking characters, and ening in
$bright_blue    '.onion'$orange.

########################################################################################
"
choose xpmq ; read REMOTE_TOR_ADDR ; set_terminal
jump $REMOTE_TOR_ADD || { invalid ; continue ; } ; set_terminal
case $REMOTE_TOR_ADDR in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;; "") invalid ;;
*)
set_terminal
echo -e "
########################################################################################

    Please enter the port number for the remote server, then hit$cyan <enter>$orange.

########################################################################################

"
read REMOTE_PORT
jump $REMOTE_PORT
rm $HOME/.sparrow/config
make_sparrow_config "fulcrumremote"
break
;;
esac
done
}
