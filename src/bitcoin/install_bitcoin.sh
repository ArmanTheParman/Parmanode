function install_bitcoin {

set_terminal

install_check "bitcoin-start" 
    #first check if Bitcoin has been installed
    return_value="$?"
    if [[ $return_value = "1" ]] ; then return 1 ; fi       #Bitcoin already installed


change_drive_selection
    # abort bitoin installation if return 1
    if [[ $? == 1 ]] ; then return 1 ; fi



# set $prune_value. Doing this now as it is related to 
# the drive choice. Use variable later for setting bitcoin.conf

prune_choice 
    # make bitcoin directories in appropriate locations

make_bitcoin_directories $drive         
    # external or internal argument
    # installed entry made when parmanode/bitcoin directory made.

download_bitcoin

#setup bitcoin.conf
debug_point "about to enter make bitcoin conf"
make_bitcoin_conf
    if  [ $? -ne 0 ]
        then return 1
    fi

#make a script that service file will use
make_mount_check_script

#make service file
make_bitcoind_service_file
if [ $? == 1 ] ; then return 1 ; fi

set_terminal

echo "
########################################################################################
    
                                    SUCCESS !!!

    Bitcoin Core will begin syncing after a reboot, or you can start Bitcoin Core 
    from the Parmanode menu.

    You can also access Bitcoin functions from the Parmanode menu.
    

########################################################################################
" && installed_config_add "bitcoin-end"
enter_continue
return 0 
}

function download_bitcoin {
    #downloads
cd $HOME/parmanode/bitcoin

set_terminal
echo "
########################################################################################
    
    The current version of Bitcoin Core that will be installed is 24.0.1

    The pgp key that will be used to verify the SHA256 file list is:

                Michael Ford: E777299FC265DD04793070EB944D35F9AC3DB76A 
    
    The downloaded file will then be hased (SHA256) and compared to the hash result 
    provided by Michael Ford.
    
    You may wish to learn how to do this yourself...

            - The file containing the hashes can be found at 
              /home/$(whoami)/parmanode/bitcoin/SHA256SUMS. 
            - The corresponding signature of that file is called SHA256SUMS.asc
            - You can then hash the bitcoin .tar.gz file using this command:
                   
                   shasum -a 256 bitcoin-24.0.1-x86_64-linux-gnu.tar.gz

            - After a few seconds you'll get a hash. Compare it to the one listed 
              by Michael Ford.

    Hit <enter> to keep reading.

########################################################################################
"
read ; set_terminal
echo "
########################################################################################
    
            - Next, if you don't feel like trusting Michael Ford is sufficiently 
              safe, you can import the public keys of anyone else who has signed the 
              file.

    What actually do these signers do?

    The take the code, written in programming language, and compile it (convert it
    to machine code, ie binary) then zip the result. This produces one file that they 
    hash.If there is any tampering of the code, the hash produced will change. If many
    people who read the code are providing the same hash, we can be confident sure 
    there hasn't been any funny business between the time they check to when you got 
    your hands on a copy.

    They then digitally sign the document that contains the hash that they vouch for. 
    The way digital signatures work is fascinating and worth learning about. You don't 
    have to be a cryptogrphy PhD to get the gist of it. It is the basis of how Bitcoin
    transactions work, and how nodes verify transactions.

    For more information on PGP, I have detailed guides:

    https://armantheparman.com/gpg-articles/

########################################################################################

Hit <enter> to continue." # don't change
echo ""
#    Do not use "enter_continue" here. See next lines for explanation.

read #using custom function "enter_continue" here produced a strange error I don't 
     #understand. Somehow the read command inside the function was reciving input, I
     #think from the calling function, maybe, and the code proceeds to download (next
     #line) without any user input to continue."

set_terminal ; echo "Downloading Bitcoin files to $HOME/parmanode/bitcoin ..."
wget  https://bitcoincore.org/bin/bitcoin-core-24.0.1/SHA256SUMS 
wget  https://bitcoincore.org/bin/bitcoin-core-24.0.1/SHA256SUMS.asc 
wget  https://bitcoincore.org/bin/bitcoin-core-24.0.1/bitcoin-24.0.1-x86_64-linux-gnu.tar.gz
sha256sum --ignore-missing --check SHA256SUMS

set_terminal

#gpg check

gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys E777299FC265DD04793070EB944D35F9AC3DB76A

    if gpg --verify SHA256SUMS.asc 2>&1 | grep -q "Good" 
    then
        echo "GPG verification of the SHA256SUMS file passed. "
        echo "Continuing with instalation."
        enter_continue
    else 
        echo "GPG verification failed. Aborting." 
        enter_continue
        exit 1
    fi
#unpack Bitcoin core:

mkdir $HOME/.parmanode/temp/ >/dev/null 2>&1
tar -xf bitcoin-* -C $HOME/.parmanode/temp/ >/dev/null  2>&1

#move bitcoin program files to new directory.

mv $HOME/.parmanode/temp/b*/* $HOME/parmanode/bitcoin/

#delete sample bitcoin.conf to avoid confusion.

rm $HOME/parmanode/bitcoin/bitcoin.conf 

#"installs" bitcoin and sets to writing to only root for security. Read/execute for group and others.
sudo install -m 0755 -o root -g root -t /usr/local/bin $HOME/parmanode/bitcoin/bin/*

sudo rm -rf $HOME/parmanode/bitcoin/bin
debug_point "debugging..."
return 0      # abort bitoin installation if return 1
}
