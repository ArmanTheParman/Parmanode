function set_terminal {
# sets terminal size
while true ; do

[[ -n $2 ]] && { #then 1 and 2 must be set
printf "\033[8;%s;%st" $1 $2
break
}

[[ -n $1 && -z $2 ]] && { #then only 1 i set
printf "\033[8;%s;88t" "$1" 
break
}

[[ -z $1 ]] && { #then none are set
printf "\033[8;38;88t"   
break
}
break
done

echo -e "$orange" #Orange colour setting.
tput clear
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