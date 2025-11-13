function status_parmanode {
file=$dp/p4_installed.conf
tempfile=/tmp/p4.conf
rm $tempfile

grep '\-end' $HOME/.parmanode/installed.conf | cut -d \- -f1 | while IFS= read -r line ; do
  echo "$line" | jq -R . >> $tempfile
done

{
echo -n "["
paste -s -d, $tempfile | tr -d '\n'
echo "]"
} > $file

}