function swap_string {
#will replace entire line containing search string with the new line
input_file="$1"
search_string="$2"
new_line="$3"

if [[ ! -f "$input_file" ]]; then
    echo "Error: $input_file does not exist."
    enter_continue
    return 1
fi

if [[ $OS == "Mac" ]] ; then 
debug1 "in swapstring, pre-perl. arg1 is $1 arg2 $2 arg3 $3"
sudo perl -pi -e 's/^.*$search_string.*$/$new_line/g' $1
debug1 "after perl"
fi

if [[ $OS == "Linux" ]] ; then
sudo sed -i '/$search_string/c\$new_line/' "$input_file"
fi

}
