# searches for a string, then delete that line for all occurrances of the string.
# arguments should use full paths to file.
# careful if the search string has / , then there can be errors

# argument 1 - input file
# argument 2 - searchstring

function delete_line {

if cat $HOME/.parmanode/installed.conf | grep -q parmanode-end ; then 
true
else
return 1
fi

if [[ $OS == "Mac" ]] ; then
	change_string_mac "$1" "$2" "null" "delete"
	return 0
fi		

search_string="$2"
input_file="$(readlink -f "$1")"	# to assign absolute path
sudo sed -i "/${search_string}/d" "$input_file" 
}

