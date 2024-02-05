function cc_firmware_instructions {

set_terminal ; echo -e "
########################################################################################
$cyan
                 Instructions to import firmware into the ColdCard
$orange

    Parmanode has downloaded the new firmware file for you and verified it is 
    ${green}GENUINE.$orange Nice.
    
    Now you need to do the following....

            1)    Put the microSD card from the CC into this computer.

            2)    Copy the file ending in '.dfu' from the directory:
                 $cyan $hp/coldcard/ $orange
                  to the microSD card

            3)    Eject the microSD card and put it in the CC

            4)    On the device go to Advanced --> Upgrade --> From MicroSD

            5)    Select the file to import and wait.

            6)   $green ENJOY$orange

########################################################################################
"
enter_continue
}