function pre_install_mac {

echo "
########################################################################################


                                   Preparation 
    

    Parmanode will download binaries that I compiled from source (available on 
    GitHub). The binaries were compiled on a Mac computer, saving you the technical 
    trouble. They two necessary files (bitcoind and bitcoin-cli) are archived into 
    one file, which I have signed with my gpg key.
    
    Parmanode will download the archive file, extract it and move the binary files 
    to the directory they belong (/etc/usr/bin). The archive file will be left in: 
    
                           $HOME/parmanode/bitcoin 

    for you to verify yourself at any time. You will need my pgp key which you can 
    source from my website, keybase, Twitter, or GitHub (it defeats the purpose if 
    I give the key to you within this software). You may also hash the file and 
    compare the result with what is published on GitHub. For more information about 
    pgp keys and software verification, you can visit:

    
                           http://armantheparman.com/gpg


########################################################################################
"
choose "epq"
read choice
if [[ $choice == "q" ]] ; then exit 0 ; fi
if [[ $choice == "p" ]] ; then return 1 ; fi
return 0
}
