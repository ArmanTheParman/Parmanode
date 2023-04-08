# added a debug function with slightly more complexity than
# a read command, to stop any arguments being passed to read
# without my knowledge. Only the character "d" will allow th
# code to contine.

function debug_point {

echo "$1"

while true
do
    echo "
debug point - hit "d" and <enter> to proceed."
read choice

if [[ $choice == "d" ]] ; then break ; fi
done
return 0
}
	
