function pre_install_mac {

# need to divide in to x86 chips and M2 chips

chip=$(uname -m)

if [[ $chip == "x86_64" ]] ; then echo "
########################################################################################


                             Download Bitcoin for Mac 
    
    Parmanode will download binaries that I compiled from Bitcoin source files 
    (files available on http://github.com/bitcoin/bitcoin/, release tag v24.0.1).

    The binaries were compiled on a Mac x86_64 computer, saving you the technical 
    trouble. There are two necessary binary files (bitcoind and bitcoin-cli) are 
    archived into one file, which I have signed with my gpg key.
    
    Parmanode will download the archive file, extract it and move the binary files 
    to the directory they belong (/etc/usr/bin). The archive file will be left in: 
    
                           $HOME/parmanode/bitcoin 

    for you to verify yourself at any time. You will need my pgp key which you can 
    source from my website (armantheparman.com), keybase, Twitter, or GitHub (it 
    defeats the purpose if you use the key given to you within this software - see 
    the about menu). You may also hash the file and compare the result with what is 
    published on GitHub. For more information about pgp keys and software 
    verification, you can visit:
    
                         http://armantheparman.com/gpg-articles



########################################################################################
"
choose "epq"
read choice
if [[ $choice == "q" ]] ; then exit 0 ; fi
if [[ $choice == "p" ]] ; then return 1 ; fi
fi #ends x86_64 chip




if [[ $chip == "arm64" ]] ; then set_terminal ; echo " 
########################################################################################


                             Download Bitcoin for Mac 
    
    Parmanode will download binaries that I compiled from Bitcoin source files 
    (files available on http://github.com/bitcoin/bitcoin/, release tag v24.0.1).

    The binaries were compiled on a Mac M1 chip computer, saving you the technical 
    trouble. This is compatible with M1 or M2 versions of Mac. There are two 
    necessary binary files (bitcoind and bitcoin-cli) are archived into one file, 
    which I have signed with my gpg key.
    
    Parmanode will download the archive file, extract it and move the binary files 
    to the directory they belong (/etc/usr/bin). The archive file will be left in: 
    
                           $HOME/parmanode/bitcoin 

    for you to verify yourself at any time. You will need my pgp key which you can 
    source from my website (armantheparman.com), keybase, Twitter, or GitHub (it 
    defeats the purpose if you use the key given to you within this software - see 
    the about menu). You may also hash the file and compare the result with what is 
    published on GitHub. For more information about pgp keys and software 
    verification, you can visit:

    
                           http://armantheparman.com/gpg


########################################################################################
"
choose "epq"
read choice
if [[ $choice == "q" ]] ; then exit 0 ; fi
if [[ $choice == "p" ]] ; then return 1 ; fi
fi #ends ARM chip

debug_point "Unknown chip. Aborting." ; enter_exit ; exit 1
}
