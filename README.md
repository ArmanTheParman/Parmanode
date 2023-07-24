# Parmanode 3.4.5

#### Instructions to install at the end

## Introduction

For Mac (x86_64, M1/M2), Linux (x86_64, and Raspberry Pi 32 or 64 bit)

Parmanode is an automated installation wizard and menu for desktop
computers, with the following software (list is growing). You don't have
to install all of them, Parmanode lets you select what you want
to include:

                Bitcoin
                Electrum Server (Fulcrum) - via Docker
                LND
                BTCPay (Linux only) +/- over Tor
                Docker
                Tor
                Mempool Space
                Sparrow Bitcoin Wallet
                Ride The Lightning Wallet
                Electrum Desktop Wallet
                Darknet Tor Server (Linux Only)
                Educational material by Parman

Parmanode is designed for non-technical users giving them the ability to 
download and verify Bitcoin related software, and sync using an external 
or internal drive, and also have configuration options presented to them
with automation. No manual configuration file editing will be required -
Parmanode takes care of all that in the background.

Users only need to read the menu options CAREFULLY, and respond to
the questions - no command line interaction is ever needed. For example, 
from a menu, bitcoin-cli commands are available, pruning can be activated 
and rpcuser/rpcpassword can also be set.

The software also comes with helpful information, including links to various
articles on my website, armantheparman.com, so that Bitcoiners keep learning
more about Bitcoin and how to be safely self-sovereign. Information on how 
to connect various wallets to the node is provided, altough, Parmanode gives
options connects the wallet for the user in the background. For example,
in the Parmanode Sparrow menu, you can choose an option to connect Sparrow
to your own node, a Fulcrum/Electrum server on the same computer, or
to your own Fulcrum/Electrum server via Tor, or to an external computer via
Tor. All the configuration is done automatically.

The most basic usage would be an internal drive to sync the Bitcoin
blockchain, running the latest version of Bitcoin Core, and connecting 
Sparrow Bitcoin Wallet or Specter Desktop Wallet directly to the node on 
the same computer.

While I tried to avoid it, for now, Mac users who wish to use Fulcrum will
follow the wizard menu options. Connecting me be problematic, so I 
recommend for now that Mac users use Bitcoin Core and Sparrow on the same
computer, and let Parmanode connect the two. If you want to use Sparrow
or Electrum with an Electrum Wallet, the better way would be to use a 
Linux machine, at least for now.

## DRIVE STRUCTURE 

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
                |--- tor-server-move          Put files here before adding to server 
                |--- tor-server               Location of darkweb server files

If an external drive is used, a symlink on the internal drive will point to the .bitcoin directory.

               /|--- .bitcoin ----|
                |--- fulcrum_db---|

## HOW TO RUN / INSTALL

Open the terminal application and type the following (and hit \<enter\> after each line.
Also, do note it is case sensitive):

    cd ~/Desktop
    git clone http://github.com/armantheparman/parmanode.git
    cd parmanode
    ./run_parmanode.sh

If you don't like all that typing, copy and paste the following single line into terminal
and hit \<enter\>:

    cd Desktop && git clone http://github.com/armantheparman/parmanode.git && cd parmanode && ./run_parmanode.sh

On some Linux distributions, git may not be installed by default so the git command above may not work
initially. You'll need to install git like this...

    sudo apt update -y && sudo apt install git -y

You can then close terminal, open it again, and try the sequence of commands above again.

On Macs, to use git, you may be asked to install the *command line developer tools*. You
will be given the option to do so with a popup window, and you'll need to proceed with 
it to use git. It takes a few minutes to install.

If you get a fingerprint error/warning when you run the git clone, that's fine, carry on.

From then on, to run Parmanode, you can double click the run_parmanode.sh file. If you
get a popup, choose to "run in terminal". Alternatively you can open terminal, navigate to
the right directory with 
    
    cd Desktop/parmanode

Then run the proram:

    ./run_parmanode.sh


## An important note about the naming and location of parmanode

The program will create a directory structure on your computer, as shown above under
"drive structure". One of these directories is called "parmanode". This is a PROGRAM
directory where all the installed stuff is kept. This is different to the SCRIPT 
parmanode directory which is the one you download containing the code (and where the
run_parmanode.sh file lives). If you download that directory to inside the home directory, 
then when the new directory is created, it will overwrite the scrip directory! This I 
didn't anticipate when nameing the directories. Changing it now is a massive task, so 
for now, I've simply prevented parmanode from working if you keep it in this location. 
If you really wanted to keep the script directory in the home directory, you can rename
it to something other than "parmanode". 

## A note about superuser

When the program runs, you will be asked at some point for a password - this is your 
computer's "sudo" or login password, and is necessary for Parmanode to access system 
functions like mounting drives.

Please be aware, you cannot run the program as the root user. You'd need to create a new
user with it's own home directory, and also give it a password and sudo permission.

## Run on a VPS

You can install Parmanode on a virtual private server but be aware the data requirement
can get expensive unless you run it pruned. Remember you can't run as root.
 

## INSTRUCTIONS TO UPGRADE

If you have any version of Parmanode 2.x.x, going to version 3.x.x, you need to uninstall 
version 2 of Parmanode before installing version 3. You don't need to delete the Bitcoin 
blockchain.

Otherwise, use the parmanode menu to upgrade to the latest version.
You could also just type "git pull" from within the parmanode SCRIPT directory.
 
