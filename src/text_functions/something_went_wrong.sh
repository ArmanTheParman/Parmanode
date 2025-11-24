function sww {
[[ $return == "true" ]] && return 0
[[ $1 == "silent" ]] && return 0

echo -e "    ${blue}Something went wrong
	
$1	
"
export swwflag="true"
enter_continue
jump $enter_cont
case $enter_cont in tmux) tmux ;; esac
}