function vim_warning {

if grep -q vimisthebest < $hm ; then return 0 ; fi

announce "Using vim is hard. To exit, use <esc> then : then q then <enter>
    Type 'vimisthebest' to dismiss this reminder permanently"

if [[ $enter_cont == "vimisthebest" ]] ; then
echo "vimisthebest=1" | tee -a $hm
fi

}