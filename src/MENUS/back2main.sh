function back2main {

export main_loop=$((main_loop + 1)) 
if [[ $main_loop -gt 50 ]] ; then
announce "The main menu function has called itself a few too many times. It's
    probably a good idea to quit Parmanode and restart it - this will release
    some of the computer's memory."
fi
menu_main

#redundant...
exit
}

function backtomain {
back2main 
}