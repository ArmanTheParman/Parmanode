# searches for a string, then delete that line for all occurrances of the string.

# arguments should use full paths to file.

function delete_line {

#input_file="$(readlink -f "$1")"
input_file="$1"
search_string="$2"

	if [[ $OS == "Linux" ]] 
	then
	sudo sed -i "/${search_string}/d" "$input_file" 
        fi


	if [[ $OS == "Mac" ]]
	then
	sudo sed -i "" "/${search_string}/d" "$input_file" 
	fi		

return 0
}
