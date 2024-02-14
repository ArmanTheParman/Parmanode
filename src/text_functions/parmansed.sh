function parmased {
# $1 is filename
# $2 is search string
# $3 is new strin
# $4 is placment

search_count=$(cat $1 | grep $2 | wc -l)

if [[ $search_count -gt 1 ]] ; then
echo -e "

More than one search match found. Continue?

y -- yes

a -- abort
"
read choice
case $choice in a) return 1 ;; esac





}