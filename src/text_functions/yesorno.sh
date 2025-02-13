function yesorno_blue {

if [[ -n $2 ]] ; then
y=$2
else
y="y"
fi

if [[ -n $3 ]] ; then
yes=$3
else
yes="yes"
fi

if [[ -n $4 ]] ; then
n=$4
else
n="n"
fi

if [[ -n $5 ]] ; then
no=$5
else
no="no"
fi


while true ; do
set_terminal ; echo -ne "$blue
########################################################################################

    $1
$orange
                            $y)$blue   \r\033[49C$yes
$orange
                            $n)$blue   \r\033[49C$no

########################################################################################

    Type '${cyan}y$orange' or '${cyan}n$orange' then $green<enter>$orange
    OR '${red}q$orange' to quit, or '${red}m$orange' for main menu

"
read choice
case $choice in
q|Q) exit ;; m|M) back2main ;;
"$y") return 0 ;;
"$n") return 1 ;;
*)
invalid
;;
esac
done
}



function yesorno {

if [[ -n $2 ]] ; then
y=$2
else
y="y"
fi

if [[ -n $3 ]] ; then
yes=$3
else
yes="yes"
fi

if [[ -n $4 ]] ; then
n=$4
else
n="n"
fi

if [[ -n $5 ]] ; then
no=$5
else
no="no"
fi


while true ; do
set_terminal ; echo -ne "
########################################################################################

    $1
$cyan
                            $y)$orange   \r\033[49C$yes
$cyan
                            $n)$orange   \r\033[49C$no

########################################################################################

    Type '${cyan}y$orange' or '${cyan}n$orange' then $green<enter>$orange
    OR '${red}q$orange' to quit, or '${red}m$orange' for main menu

"
read choice
case $choice in
q|Q) exit ;; m|M) back2main ;;
"$y") return 0 ;;
"$n") return 1 ;;
*)
invalid
;;
esac
done
}


