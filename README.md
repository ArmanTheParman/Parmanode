# Parmanode 2.1.0 Plebian Cheese 

For Mac (x86_64, M1/M2), Linux (x86_64, and Raspberry Pi 32 or 64 bit)
18 April 2023

Parmanode is a software package for home computers (Linux, Mac, and
maybe one day, Windows). Support for Raspberry Pi 32 bit and 64 bit running 
Linux OS has been added.

Parmanode comes with an installation wizard so that non-technical users have
the ability to download and verify Bitcoin Core and sync using an external 
or internal drive, and also have configuration options presented to them
with automation. No manual bitcoin.conf file editing will be required.

All people need to do is read the menu options carefully, and respond to
the questions - no command line interaction is required. For example, 
bitcoin-cli commands are available in a menu, and pruning can be activated 
from menu options.

The software also comes with helpful information, including links to various
articles on my website, armantheparman.com, so that Bitcoiners keep learning
more about Bitcoin and how to be safely self-sovereign. Information on how 
to connect various wallets to the node is provided in the menus. Much effort
has not been made for this aspect of the software in the first version; more
will be done later.

The most basic usage would be an internal drive to sync, running the latest
version of Bitcoin Core, and connecting Sparrow Bitcoin Wallet or Specter
Desktop Wallet directly to the node on the same computer.

## Software included

### Bitcoin 24.01

Verification public key: E777299FC265DD04793070EB944D35F9AC3DB76A
       
DRIVE STRUCTURE (for when Parmanode software is installed with Bitcoin Core):

Internal drive:
               
               /|--- $HOME ---|
                |             |--- .bitcoin                        (may or may not be a symlink)
                |             |--- .parmanode                      (config files)
                |             |--- parmanode ---|
                |                               |--- bitcoin ---|  (keeps B core download and pgp stuff)
                |--- media ---|
                |             |--- parmanode ---|                  (ext drive mountpoint) 
                |                               |--- .bitcoin ---| (symlink target)
                |           
                |--- usr  --- |--- local  ------|--- bin ---|       (keeps bitcoin binary files)


If an external drive is used, a symlink on the internal drive will point to the .bitcoin directory.

               /|--- .bitcoin ---|

### Fulcrum v1.9.1 for Linux x86_64 and ARM64 (Pi) only. Not Mac (yet).

## HOW TO RUN

Stable:
	Find the latest tag and download/unzip that to a directory on your drive.
	To run it, 'cd' into the downloaded directory ("Parmanode"), then type './run_parmanode'
Latest:
	Easy way - Navigate to the github repository, and click the green 'code' button. 
        In the pop-uo, click download zip, then proceed as instructed in stable version.
        
        Easier way - coming soon.

	Surest way - Run this command in terminal:
	git clone http://github.com:armantheparman/parmanode.git
        It will download a directory called "parmanode" to your working directory
	Then cd parmanode, to change into that directory.
	Then type './run_parmanode'

## INSTRUCTIONS TO UPGRADE

        Simply download a new version and run it. You can delete the old copy but do not touch
        any of the directories or files that Parmanode has made. 

        You do not need to uninstall the old Parmanode or uninstall Bitcoin. When a new version
        of Bitcoin is oferred by Parmanode, the software will ask what you want to do.

