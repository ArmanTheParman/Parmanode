function set_terminal {
# sets terminal size
while true ; do

[[ -n $2 ]] && {
printf "\033[8;%s;%st" $1 $2
break
}

[[ -n $1 && -z $2 ]] && {
    reap -p "n1 z2" 
printf "\033[8;%s;88t" "$1" 
    reap -p pause
break
}

[[ -z $1 ]] && {
printf "\033[8;38;88t"   
break
}
break
done


echo -e "$orange" #Orange colour setting.


tput clear


return 0

}

function set_terminal_wide {
if [[ -n $1 ]] ; then val="$1" ; else val=38 ; fi
set_terminal
printf '\033[8;%s;110t' $val

return 0
}

function set_terminal_big {

set_terminal
printf '\033[8;50;110t'

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
if [[ -z $2 ]] ; then
set_terminal
printf "\033[8;%s;88t" $1
return 0
fi

set_terminal
printf "\033[8;%s;%st" $1 $2
}