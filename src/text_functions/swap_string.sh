# $1 file name 
# $2 search string 
# $3 change whole line to
alias string_swap='swap_string' >/dev/null

function swap_string {
if [[ $OS == "Mac" ]] ; then
change_string_mac "$1" "$2" "$3" swap "$4" >> $HOME/.parmanode/change_string_mac.log 2>&1
return 0
fi

#will replace entire line containing search string with the new line
input_file="$1"
search_string="$2"
new_line="$3"


if [[ ! -f "$input_file" ]]; then
    echo -e "Error: $input_file does not exist."
    enter_continue
    return 1
fi

#every ocurranced swapped - just some log info...
echo -e "swap string: $search_string new line: $new_line input file: $input_file" >> $HOME/.parmanode/sed.log 

#be very careful modifying this...
sudo sed -i "/$search_string/c\\$new_line" "$input_file" >> $HOME/.parmanode/sed.log 2>&1
}
