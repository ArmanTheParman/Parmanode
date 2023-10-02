function download_bitcoin_linux {
cd $HOME/parmanode/bitcoin

set_terminal
echo -e "
########################################################################################
    
    The current version of Bitcoin Core that will be installed is 25.0

    The downloaded file will then be hased (SHA256) and compared to the hash result 
    provided by the signers.
    
    You may wish to learn how to do this yourself.

            - The file containing the hashes can be found at 
              /home/$(whoami)/parmanode/bitcoin/SHA256SUMS. 
            - The corresponding signature of that file is called SHA256SUMS.asc
            - You can then hash the bitcoin tar.gz file using this command:
                   
                   shasum -a 256 bitcoin-24.0.1-x86_64-linux-gnu.tar.gz

            - After a few seconds you'll get a hash. Compare it to the one listed 
              in the SHA256SUMS file.

########################################################################################
"
enter_continue

set_terminal ; echo "Downloading Bitcoin files to $HOME/parmanode/bitcoin ..."

curl -LO https://bitcoincore.org/bin/bitcoin-core-25.0/SHA256SUMS 
curl -LO https://bitcoincore.org/bin/bitcoin-core-25.0/SHA256SUMS.asc 

# ARM Pi4 support. If not, checks for 64 bit x86.

	    if [[ $chip == "armv7l" || $chip == "armv8l" ]] ; then 		#32 bit Pi4

		        curl -LO https://bitcoincore.org/bin/bitcoin-core-25.0/bitcoin-25.0-arm-linux-gnueabihf.tar.gz ; fi

	    if [[ $chip == "aarch64" ]] ; then 				

            if [[ $( file /bin/bash | cut -d " " -f 3 ) == "64-bit" ]] ; then
                curl -LO https://bitcoincore.org/bin/bitcoin-core-25.0/bitcoin-25.0-aarch64-linux-gnu.tar.gz 
            else
                curl -LO https://bitcoincore.org/bin/bitcoin-core-25.0/bitcoin-25.0-arm-linux-gnueabihf.tar.gz ; fi
            fi

	    if [[ $chip == "x86_64" ]] ; then 
		        curl -LO https://bitcoincore.org/bin/bitcoin-core-25.0/bitcoin-25.0-x86_64-linux-gnu.tar.gz ; fi

verify_bitcoin || return 1

#unpack Bitcoin core:
set_terminal
mkdir $HOME/.parmanode/temp/ >/dev/null 2>&1
tar -xf bitcoin-* -C $HOME/.parmanode/temp/ >/dev/null 2>&1

# Move bitcoin program files to new directory.
# All binaries go to $HOME/parmanode/bitcoin.
mv $HOME/.parmanode/temp/b*/* $HOME/parmanode/bitcoin/

#delete sample bitcoin.conf to avoid confusion.
rm $HOME/parmanode/bitcoin/bitcoin.conf 

# "installs" bitcoin and sets to writing to only root for security. Read/execute for group and others. 
# makes target directories if they don't exist
# "install" is just a glorified copy command
sudo install -m 0755 -o $(whoami) -g $(whoami) -t /usr/local/bin $HOME/parmanode/bitcoin/bin/*

sudo rm -rf $HOME/parmanode/bitcoin/bin
return 0     
}
