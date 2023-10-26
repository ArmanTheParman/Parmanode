# searches for a string, then delete that line for all occurrances of the string.
# arguments should use full paths to file.
# careful if the search string has / , then there can be errors

# argument 1 - input file
# argument 2 - searchstring

function delete_line {
if [[ ! -d $dp/.backup_files ]] ; then mkdir $dp/.backup_files ; fi

cp $1 $dp/.backup_files/$1$(date | awk '{print $1$2$3}') >/dev/null 2>&1

#program exits if parmanode not "installed"- preventing the use of the function before installation 
if grep -q parmanode-end < $HOME/.parmanode/installed.conf ; then 
true
else
return 1
fi >/dev/null 2>&1

if [[ $(uname) == "Darwin" ]] ; then
	change_string_mac "$1" "$2" "null" "delete"
	return 0
fi		

# For Linux...
search_string="$2"
input_file="$(readlink -f "$1")"	# to assign absolute path
echo "delete line $search_string, input file $input_file" >> $HOME/.parmanode/sed.log 2>&1  
sudo sed -i "/${search_string}/d" "$input_file" >> $HOME/.parmanode/sed.log 2>&1
# I will need to change the delimeter in the sed command to @ later instead of / to
# avoid a bug if the search_strin contains a /.
# Everything is working now, so not urgent.
}

