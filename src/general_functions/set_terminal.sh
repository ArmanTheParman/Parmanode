function set_terminal {

printf '\033[8;38;88t'

if [[ $OS == "Linux" ]] ; then
    echo -e "\033[38;2;255;145;0m" #Orange colour setting
elif [[ $OS == "Mac" ]] ; then
    echo -e "\033[38;5;208m"        #won't work in /bin/zsh, but script runs in /bin/bash which works.
fi

clear
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


