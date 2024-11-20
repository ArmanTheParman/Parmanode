function less_function {

set_terminal ; announce "When you hit$cyan <enter>$orange a reader will open up. You can scroll up and down with 
    the arrows (our use VIM keys if you know what that is.)

    To exit, just hit$red q$orange then$cyan <enter>$orange
"

set_terminal_bit_higher

if [[ $1 == "6rn" ]] ; then less $pn/src/education/6rn.txt ; fi

if [[ $1 == "joinus" ]] ; then less $pn/src/education/joinus.txt ; fi

set_terminal
}