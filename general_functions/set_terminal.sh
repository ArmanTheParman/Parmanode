function set_terminal {

printf '\033[8;38;88t'
echo -e "\033[38;2;255;145;0m"

clear

return 0
}

function set_terminal_wide {

printf '\033[8;38;110t'

clear

return 0
}

function set_terminal_wider {

set_terminal

printf '\033[8;38;200t'

return 0
}
