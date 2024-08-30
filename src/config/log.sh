# Usage: Argument 1 should be the name of the program. Argument 2 is the message.
#        Argument 2 can be "delete" which will remove the file name "argument1".log

function log {

if [[ $2 == "delete" ]] >/dev/null 2>&1 ; then
rm $dp/"$1".log >/dev/null 2>&1
fi

#log message in individual file
echo "$(date) $2" >> $dp/"$1".log 2>$dn

#log message all in one file
echo "$(date) $2" >> $dp/parmanode_all.log 2>$dn
}