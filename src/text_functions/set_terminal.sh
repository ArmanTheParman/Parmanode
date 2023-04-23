function set_terminal {
colour=$1

printf '\033[8;38;88t'   # sets terminal size

echo -e "\033[38;2;255;145;0m" #Orange colour setting
        
        # alternative format saved for future use
        # echo -e "\033[38;5;208m" - won't work in /bin/zsh, but script runs in /bin/bash which works.


if [[ $colour = "pink" ]] ; then echo -e "\033[38;2;255;0;255m" ; fi

tput clear
return 0
}

function set_terminal_wide {

set_terminal
printf '\033[8;38;110t'

return 0
}

function set_terminal_wider {

set_terminal
printf '\033[8;38;200t'

return 0
}

function set_terminal_high {
set_terminal
printf '\033[8;47;88t' 
return 0
}

function set_terminal_bit_higher {
set_terminal
printf '\033[8;43;88t' 
return 0
}