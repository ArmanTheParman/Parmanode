function truncatedebuglog {
#debug
debuglength=$(wc -l < "$dp/debug.log" | xargs)
if [[ $debuglength -gt 2000 ]] ; then
tail -n 2000 $dp/debug.log > $dp/debug.log >/dev/null 2>&1
fi
#debug2
debuglength=$(wc -l < "$dp/debug2.log" | xargs)
if [[ $debuglength -gt 2000 ]] ; then
tail -n 2000 $dp/debug.log > $dp/debug2.log >/dev/null 2>&1
fi
}