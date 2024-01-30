function get_unique_line {
# $1 file 1
# $2 file 2
# Returns single unique line in file 2.
# Returns error if file 2 not 1 line longer than file 1.


length_1=$(cat "$1" | wc -l)
length_2=$(cat "$2" | wc -l)

debug " In get_unique_line. Variables:

   1 - $1
   2 - $2

   length_1 - $length_1
   length_2 - $length_2

"


if [[ $((length_2 - length_1)) != 1 ]] ; then
debug "file 2 is not one line longer than file 1"
return 1
fi

for i in $(seq 1 $length_2) ; do
debug "line 28, i is $i"
if grep -q "$(head -n $i "$2")" < "$1" ; then
continue
else
debug "line 32, i is $i"
debug "unique line is $(head -n $i $2)"
echo "Drive name detected is...$(head -n $1 $2)"
sleep 2
debug "line 36, i is $i"
echo "$(head -n $i $2)" > $dp/.unique_line
break
fi
done

}