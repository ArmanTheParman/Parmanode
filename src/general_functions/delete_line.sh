# searches for a string, then delete that line for all occurrances of the string.
# arguments should use full paths to file.

function delete_line {

input_file=$1
search_string=$2


	sed -i "/${search_string}/d" "$input_file" 

return 0
}
