function menu_drive {

# formats the external drive if selected.
# bitcoin_data directories made on either the internal or external drive.

while true
do
clear
echo "

You have the option to use an external or internal hard drive to keep the Bitcoin blockchain data, and other programs' data.



Please choose an option:

1 - Prepare an EXTERNAL drive

2 - Prepare an INTERNAL drive

Type 1, 2, p for previous, or q to quit, then <enter>.

"
read choice
   
case $choice in
1)
echo "
Note, it is strongly recommended that you use a solid state drive (regardless if it is internal or external),
otherwise you're going to have a bad time.

Go ahead and connect the drive to the computer if you haven't done so. Or, hit Control-C to quit.

Once the drive is recognised by the computer (mounted), hit <enter> to continue...
"
read
format_ext_drive
return 0
;;

2)
prepare_internal_drive
return 0
;;

p)
return 0
;;

q | Q | quit)
exit 0
;;
*)
clear
echo "Invalid entnry, hit <enter> to try again. "
read
;;  
esac
done
}
