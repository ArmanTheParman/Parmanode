function sww {
echo -e "    ${blue}Something went wrong
	
$1	
"
export swwflag="true"
enter_continue
case $enter_cont in tmux) tmux ;; esac
}