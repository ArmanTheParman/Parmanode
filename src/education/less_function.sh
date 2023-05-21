function less_function {

set_terminal ; echo "

When you hit <enter> a reader will open up. You can scroll up and down with 
the arrows (our use VIM keys if you know what that is.)

To exit, just hit q then <enter>
"
enter_continue

set_terminal_bit_higher

if [[ $1 == "6rn" ]] ; then less $original_dir/src/education/6rn.txt ; fi

if [[ $1 == "joinus" ]] ; then less $original_dir/src/education/joinus.txt ; fi

set_terminal
}