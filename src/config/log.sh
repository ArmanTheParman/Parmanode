# Usage: Argument 1 should be the name of the program. Argument 2 is the message.
#        Argument 2 can be "delte" which will remove the file name "argument1".log

function log {

if [[ $2 == "delete" ]] >/dev/null 2>&1 ; then
rm $HOME/.parmanode/"$1".log
fi


echo "$(date) $2" >> $HOME/.parmanode/"$1".log


}