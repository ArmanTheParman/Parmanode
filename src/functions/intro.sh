function intro {
set_terminal

while true
do

echo "
########################################################################################

    Welcome to PARMANODE, an easy AF way to install and run Bitcoin on your computer, 
    with the option of additional related programs.
	
########################################################################################


	Requirements:

        	1) Linux
                2) AMD/Intel 64 architecture (x86-64)
        	3) An external drive (1 Tb) OR and internal drive with spare capacity
        	4) User must not hold ANY shitcoins


	For more info, see www.parmanode.com
       
	To report bugs, armantheparman@gmail.com


########################################################################################

Hit <enter> to continue, or (q) to quit, then <enter>.

If you hold shitcoins, please hit (s) - be honest!
"

read choice

if [[ $choice == "s" || $choice == "S" ]] ; then dirty_shitcoiner ; continue ; fi
if [[ $choice == "q" || $choice == "Q" ]] ; then exit 0 ; fi
return 0
done
}

