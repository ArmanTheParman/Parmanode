# Parmanode 3.3.0 Plebian Cheese 

For Mac (x86_64, M1/M2), Linux (x86_64, and Raspberry Pi 32 or 64 bit)

Version 3 of Parmanode begins the introduction of LND. For Linux
OS only currently.

Version 3 is not fully backwards compatible with earlier versions,
it's best to fully uninstall previous versions before using version 3.
Blockchain data does not need to be deleted.

Parmanode is an automated installation wizard and menu for desktiop
computers, with the following software (list is growing):

                Bitcoin
                Electrum Server (Fulcrum)
                BTCPay 
                Docker
                Tor
                Mempool Space
                Sparrow Bitcoin Wallet
                Ride The Lightning Wallet
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

### Tor (latest)

### LND v0.16.2 

### Mempool Space (latest)

### Sparrow Bitcoin Wallet (1.7.6)

### Ride The Lightning (latest)

DRIVE STRUCTURE (for when Parmanode software is installed with Bitcoin Core):

Internal drive:
               
               /|--- $HOME ---|
                |             |--- .bitcoin                           (may or may not be a symlink)
                |             |--- .parmanode                         (config files)
                |             |--- .btcpayserver                      (config, mounted to docker container) 
                |             |--- .nbxplorer                         (config, mounted to docker container)
                |             |--- .lnd                               (lnd database)                          
                |             |--- .sparrow                           (confit and wallet files)
                |             |--- parmanode ---|
                |                               |--- bitcoin ------|  (keeps B core download and pgp stuff)
                |                               |
                |                               |--- fulcrum ------|  (keeps Fulcrum binary and config. Volume
                |                               |                      mounted for docker version)
                |                               |
                |                               |--- fulcrum_db ---|  (fulcrum databas)
                |                               |
                |                               |--- LND ----------|  (downloaded files) 
                |                               |
                |                               |--- mempool ------|  (downloaded files)
                |                               |                                        
                |                               |--- RTL ----------|  (config and database)
                |                               |                                        
                |                               |--- Sparrow ------|  (binary)
                |                               
                |--- media ---|
                |             |--- parmanode ---|                  
                |                               |--- .bitcoin ---|    (symlink target and ext drive mountpoint)
                |           
                |--- usr  --- |--- local  ------|--- bin ---|         (keeps bitcoin binary files)
                |
                |--- Docker conatainer (btcpay) ---|
                |                                  |---home/parman/parmanode/btcpayserver
                |                                  |---home/parman/parmanode/NBXplorer
                |                                                  
                |--- 3 Docker containers                              (mempool: api, web, db)
                |--- RTL Docker 

If an external drive is used, a symlink on the internal drive will point to the .bitcoin directory.

               /|--- .bitcoin ----|
                |--- fulcrum_db---|

## HOW TO RUN

#### Stable:

Find the latest tag and download/unzip that to a directory on your drive.

It must not be the home directory (Parmanode will know and not let you run it, apologies).

To run it, 'cd' into the downloaded directory ("Parmanode"), then type './run_parmanode.sh'

Do not forget to type the ".sh" extension in the run command.

You will be asked at some point for a password - this is your computer's "sudo" or login
password, and is necessary for Parmanode to access system functions like mounting drives.

#### Latest:

Easy way - Navigate to the github repository, and click the green 'code' button. In 
           the pop-uo, click download zip, then proceed as instructed in stable version.
        
Easier way - coming soon.

Surest way - In terminal, navige to anywhere but the home directory and run this command:

                git clone http://github.com/armantheparman/parmanode.git

It will download a directory called "parmanode" to your working directory. Then cd 
parmanode, to change into that directory. Then type './run_parmanode.sh'

Note that you may get a fingerprint error by the terminal when you run the git clone
command; that's ok, it's safe to proceed.

## INSTRUCTIONS TO UPGRADE

If you have any version of Parmanode 2.x.x, going to version 3.x.x, you need to uninstall version 2 of Parmanode before installing version 3. You don't need to delete the Bitcoin blockchain

Otherwise, simply download a new version and run it.
You can delete the old copy but do not touch any of the directories or files that Parmanode has made. 
