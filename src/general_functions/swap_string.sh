#function may not be in use.


function swap_string {

input_file=$1
output_file=/tmp/temp.txt
search_string=$2
replace_string=$3

# Find and replace the string in the input file, and save the result to the output file
sed "s/${search_string}/${replace_string}/g" "$input_file" > "$output_file"

# Replace the input file with the modified output file
mv "$output_file" "$input_file"
}

#####################

#This method replaces all occurrences of the search string in the input file. 
#If you want to replace only the first occurrence, remove the g flag in the sed command:

#sed "s/${search_string}/${replace_string}/g" "$input_file" > "$output_file"
