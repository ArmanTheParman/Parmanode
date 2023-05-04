# Parmanode 2.3.4 Plebian Cheese 

For Mac (x86_64, M1/M2), Linux (x86_64, and Raspberry Pi 32 or 64 bit)
18 April 2023

Parmanode is an automated installation wizard and menu for desktiop
computers, with the following software (list is growing):

                Bitcoin
                Electrum Server (Fulcrum)
                BTCPay 
                Docker
                Tor
                Educational material by Parman

Parmanode is designed for non-technical users giving them the ability to 
download and verify Bitcoin related software, and sync using an external 
or internal drive, and also have configuration options presented to them
with automation. No manual configuration file editing will be required.

Users only need to read the menu options carefully, and respond to
the questions - no command line interaction is ever needed. For example, 
from a menu, bitcoin-cli commands are available, pruning can be activated 
and rpcuser/rpcpassword can also be set.

The software also comes with helpful information, including links to various
articles on my website, armantheparman.com, so that Bitcoiners keep learning
more about Bitcoin and how to be safely self-sovereign. Information on how 
to connect various wallets to the node is provided.

The most basic usage would be an internal drive to sync, running the latest
version of Bitcoin Core, and connecting Sparrow Bitcoin Wallet or Specter
Desktop Wallet directly to the node on the same computer.

While I tried to avoid it, for now, Mac users who wish to use Fulcrum will
need to run it in a Docker container. It has been made very easy, just 
follow the wizard menu options.

## Software versions included

### Fulcrum v1.9.1 

### Bitcoin 24.01

### BTCPay (latest)

### Docker (latest)

### Tor (lates)

Verification public key: E777299FC265DD04793070EB944D35F9AC3DB76A
       
DRIVE STRUCTURE (for when Parmanode software is installed with Bitcoin Core):

Internal drive:
               
               /|--- $HOME ---|
                |             |--- .bitcoin                           (may or may not be a symlink)
                |             |--- .parmanode                         (config files)
                |             |--- .btcpayserver                      (config, mounted to docker container) 
                |             |--- .nbxplorer                         (config, mounted to docker container)
                |             |--- parmanode ---|
                |                               |--- bitcoin ------|  (keeps B core download and pgp stuff)
                |                               |
                |                               |--- fulcrum ------|  (keeps Fulcrum binary and config. Volume
                |                               |                      mounted for docker version)
                |                               |
                |                               |--- fulcrum_db ---|  (fulcrum databas)
                |--- media ---|
                |             |--- parmanode ---|                  
                |                               |--- .bitcoin ---|    (symlink target and ext drive mountpoint)
                |           
                |--- usr  --- |--- local  ------|--- bin ---|         (keeps bitcoin binary files)
                |
                |
                |---Docker conatainer (btcpay) ---|
                                                  |---home/parman/parmanode/btcpayserver
                                                  |---home/parman/parmanode/NBXplorer
                                                                  


If an external drive is used, a symlink on the internal drive will point to the .bitcoin directory.

               /|--- .bitcoin ----|
                |--- fulcrum_db---|

## HOW TO RUN

#### Stable:

Find the latest tag and download/unzip that to a directory on your drive.
It must not be the home directory (Parmanode will know and not let you run it, apologies).
To run it, 'cd' into the downloaded directory ("Parmanode"), then type './run_parmanode.sh'
Do not forget to type the ".sh" extension in the run command.

#### Latest:

Easy way - Navigate to the github repository, and click the green 'code' button. In 
           the pop-uo, click download zip, then proceed as instructed in stable version.
        
Easier way - coming soon.

Surest way - Run this command in terminal:

                git clone http://github.com/armantheparman/parmanode.git
        or
                git clone git@github.com:armantheparman/parmanode.git

It will download a directory called "parmanode" to your working directory. Then cd parmanode, to change into that directory. Then type './run_parmanode.sh'

## INSTRUCTIONS TO UPGRADE

Simply download a new version and run it. You can delete the old copy but do not touch any of the directories or files that Parmanode has made. If you are to download to exactly the same directory, then you'll have to delete the old copy of Parmanode first, or delete it.

You do not need to uninstall the old Parmanode or uninstall Bitcoin. When a new version of Bitcoin is offered by Parmanode, the software will ask what you want to do.

