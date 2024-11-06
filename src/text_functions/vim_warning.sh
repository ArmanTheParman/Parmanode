function vim_warning {

if grep -q vimisthebest < $hm ; then return 0 ; fi

announce "Using vim is hard. To exit, use $cyan<esc>$ornage then$cyan :$orange then$cyan q$orange then$cyan <enter>$orange.

    Type 'vimisthebest' to dismiss this reminder permanently"

if [[ $enter_cont == "vimisthebest" ]] ; then
echo "vimisthebest=1" | tee -a $hm
fi

}