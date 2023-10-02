function ParmaZero_intro {

set_terminal ; echo "
########################################################################################
            $cyan
                                 P A R M A Z E R O

    ParmaZero is a Raspberry Pi Zero single board computer that's air-gapped. Userful
    for making private keys, verifying private keys, and writing sensitive letters
    for encryption, eg for inheritence. It is not ideal for STORING private keys, but
    is possible if in a multisig setup with multiple geographically disgributed
    devices. These things are slow, but quite cheap.

    This script will help you install the necessary software on to the PI OS image
    and then flash to a microSD card which you can stick into the PiZero. Then it
    becomes a ParmaZero :)

########################################################################################

    Hit n to abort or <enter> to continue.

"
read choice ; if [[ $choice == n ]] ; then return 1 ; fi

}