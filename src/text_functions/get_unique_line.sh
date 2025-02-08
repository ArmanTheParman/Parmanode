function get_unique_line {
# Returns unique lines in file 2.
debug "in get_unique_line $1 -- $2"

ul_file="$dp/.unique_line"
file1="$1"
file2="$2"

cat $file2 | while IFS= read -r line ; do {
if ! grep -q $line $file1 ; then echo "$line" >> $ul_file ; fi
}
done
}