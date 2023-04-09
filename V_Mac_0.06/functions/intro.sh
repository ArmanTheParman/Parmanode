function intro_v0.06 {

echo "
########################################################################################
Welcome to PARMANODE, an easy AF way to run Bitcoin on your computer, with the
option of additional related programs.
########################################################################################


Requirements:

1) MacOS
2) AMD/Intel 64 architecture (x86-64)
3) An external drive (1 Tb) OR and internal drive with spare capacity.



Hit <enter> to continue, or Control-C to quit.



For more info, see www.parmanode.com
To report bugs, armantheparman@gmail.com

"
read
clear

}

########################################################################################


function intro_v0.05 {
clear

echo "
Welcome to PARMANODE, an easy AF way to run Bitcoin on your computer, with the
option of additional related programs.

Requirements:

1) MacOS, Windows 7+, Linux (Debian/Ubuntu based) 

      - Out of date MacOS may work, but has not been tested.
      - Windows editions before 7 won't work.
      - Various Linux flavours may work but this has been tested only on Debian based systems. This
        includes Ubuntu and Linux Mint.
    
2) AMD/Intel 64 architecture (x86-64)

      - The program will check for this
      - Raspberry Pi computers will not work (They have ARM chips)
      - No support yet for 32 bit architecture (for later versions)
      - No support yet for M1/2 Mac processors (for later versions)

3) An external drive (1 Tb) OR and internal drive with spare capacity.

      - The EXTERNAL drive will be formatted, and driectories prepared. You
        can choose to skip formatting when prompted.
      - At least 1 Tb capacity is recommended for the external drive or 1Tb
        available unused space for an internal drive.
      - Smaller drives will be possible in pruned mode. ADVANCED: Edit the config file
        via the bitcoin menu; instructions provided.
    

At almost any time, you can exit the program with Control-C

"
Read -p "Hit <enter> to continue, or Control-C to quit. "
clear
}
