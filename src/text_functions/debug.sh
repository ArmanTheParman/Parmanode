# added a debug function with slightly more complexity than
# a read command, to stop any arguments being passed to read
# without my knowledge. Only the character "d" will allow th
# code to contine.

function debug {
echo "Debug point. Message:"
echo "$1"
log "debug" "$1"
enter_continue
return 0
}
	
function debug1 {

if [ $debug = 1 ] ; then
debug $@
fi
}