# searches for a string, then delete that line for all occurrances of the string.
# arguments should use full paths to file.
# careful if the search string has / , then there can be errors

# argument 1 - input file
# argument 2 - searchstring

function delete_line {

if cat $HOME/.parmanode/installed.conf | grep -q parmanode-end ; then 

	search_string="$2"

		if [[ $OS == "Linux" ]] 
		then
            input_file="$(readlink -f "$1")"	# to assign absolute path
			sudo sed -i "/${search_string}/d" "$input_file" 
		fi


		if [[ $OS == "Mac" ]] ; then
				change_string_mac "$1" "$2" null delete
		fi		
fi

}

