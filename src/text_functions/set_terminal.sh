function set_terminal {
colour="$1"

printf '\033[8;38;88t'   # sets terminal size

echo -e "$orange" #Orange colour setting.

        
if [[ $colour == "pink" ]] ; then echo -e "\033[38;2;255;0;255m" ; fi

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

function set_terminal_higher {
set_terminal
printf '\033[8;50;88t' 
return 0
}

function set_terminal_bit_higher {
set_terminal
printf '\033[8;43;88t' 
return 0
}

function set_terminal_custom {
set_terminal
printf "\033[8;%s;88t" $1
}
