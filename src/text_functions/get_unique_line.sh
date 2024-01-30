function get_unique_line {
file="$dp/.unique_line"
# $1 file 1
# $2 file 2
# Returns single unique line in file 2.
# Returns error if file 2 not 1 line longer than file 1.


length_1=$(cat "$1" | wc -l)
length_2=$(cat "$2" | wc -l)

if [[ $((length_2 - length_1)) != 1 ]] ; then
return 1
fi

for i in $(seq 1 $length_2) ; do
#spacing is sometimes different, so better to check awk1
if grep -q "$(sed -n ${i}p $2 | awk '{print $1}')" < "$1" ; then
continue
else
echo "Drive name detected is...$(sed -n ${i}p $2)"
sleep 2
echo "$(sed -n ${i}p $2)" > $file
unset file
break
fi
done

}