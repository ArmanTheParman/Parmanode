function sww {
[[ $return == "true" ]] && return 0
[[ $1 == "silent" ]] && return 0

echo -e "    ${blue}Something went wrong
	
$1	
"

arg2="$2"
[[ -z $arg2 ]] && arg2="Nothing here"

echo -e "\n${red}For debug:\n$arg2$orange"

export swwflag="true"


enter_continue
jump $enter_cont
case $enter_cont in tmux) tmux ;; esac
}