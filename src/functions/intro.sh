function intro {
set_terminal

while true
do

echo "
########################################################################################

    Welcome to PARMANODE, an easy AF way to install and run Bitcoin on your computer 
    with the option of additional related programs.
	
########################################################################################

	Requirements:

            1) Linux or Mac (Not available for Windows yet)

            2) CPU Architecture:

			   - AMD/Intel 64 architecture (x86-64) 
			   - or M2 Mac chip
			   - NOT ARM (Raspbery Pi) yet

            3) An ext drive (1 Tb) OR and internal drive with spare capacity

            4) Users must not hold ANY shitcoins. Honesty system
            5) Free: 
                   - Donation appreciated (if felt you received value)
                   - Honesty system, suggested: 0.002 bitcoin
                   - Or your choice
                   - Yes, the code is open source, MIT licence, like Bitoin

	To report bugs, armantheparman@protonmail.com

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

