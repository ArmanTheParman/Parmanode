function truncatedebuglog {
#debug
if [[ -e $dp/debug.log ]] ; then
debuglength=$(wc -l < "$dp/debug.log" | xargs)
if [[ $debuglength -gt 2000 ]] ; then
tail -n 2000 $dp/debug.log > $dp/debug.log >/dev/null 2>&1
fi
fi
#debug2
if [[ -e $dp/debug2.log ]] ; then
debuglength=$(wc -l < "$dp/debug2.log" | xargs)
if [[ $debuglength -gt 2000 ]] ; then
tail -n 2000 $dp/debug2.log > $dp/debug2.log >/dev/null 2>&1
fi
fi
}