function parmased {
file="$1"
# $2 is search string
# $3 is new string
# $4 is placment

search_lines=$(cat $1 | grep $2 | wc -l | tr -d ' ')
file_lines=$(cat $1 | wc -l | tr -d ' ')
if [[ $search_lines -gt 1 ]] ; then
echo -e "

More than one search match found. Continue?

y -- yes

a -- abort
"
read choice
case $choice in a) return 1 ;;
y)
echo "just doing first search found..."
sleep 3
;;
esac

#get the line number of the search (starts at line 1 not zero)
line_number=$(cat $1 | grep -nq $2 | cut -d : -f 1)

#get all lines to line number
head -n $line_number $file | sudo tee $newfile >/dev/null 2>&1

#print the new string
echo "$3" | sudo tee -a $newfile >/dev/null 2>&1

#add the rest
tail -n $((file_lines - line_number)) | sudo tee -a $newfile >/dev/null 2>&1

#rename

sudo mv $newfile $1




}