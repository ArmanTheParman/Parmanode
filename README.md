# Parmanode 3.5.1

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
                Specter Desktop
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

## READ THE CODE

I have added copious comments to the code so that a non-developer can read
it in an instructional way and learn what's going on. I expect it shouldn't
be that hard to follow. All commands in the code are executable manually in 
the terminal, so you can experiment and try out thins you see.

I suggest using sofware called Visual Studio Code (VSC), as it colour codes 
everything and makes it easier to follow the syntax. Open the parmanode 
script folder that you download from GitHub and read the code in VSC softwrae.

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

IF YOU WISH TO ENQUIRE ABOUT HIRING ME TO ASSIST WITH SETUP AND A WALKTHROUGH OF THE SOFTWARE, PLEASE SEND AN EMAIL TO ARMANTHEPARMAN AT PROTONMAIL DOT COM.

IF YOU WISH TO BUY A READY MADE PARMANODE NODE ("PARMANODL") PLEASE CONTACT ME:

    armantheparman@protonmail.com

If you want to start a new computer yourself with parmanode (build your own ParmanodL), 
then see instructions near the end.

To simply install parmanode on your existing computer, read on...

Open the terminal application and type the following (and hit \<enter\> after each line.
Also, do note it is case sensitive):

    cd ~/Desktop ; git clone http://github.com/armantheparman/parmanode.git
    cd parmanode
    ./run_parmanode.sh

On some Linux distributions, git may not be installed by default so the git command above may not work
initially. You'll need to install git like this...

    sudo apt update -y ; sudo apt install git -y

You can then close terminal, open it again, and try the sequence of commands above again.

On Macs, to use git, you may be asked to install the *command line developer tools*. You
will be given the option to do so with a popup window, and you'll need to proceed with 
it to use git. It takes a few minutes to install.

If you get a fingerprint error/warning when you run the git clone, that's fine, carry on.

From then on, to run Parmanode, you can double click the run_parmanode.sh file. If you
get a popup, choose to "run in terminal". Alternatively you can open terminal, navigate to
the right directory with 
    
    cd Desktop/parmanode

Then run the program:

    ./run_parmanode.sh

Parmanode is not designed to be run by a user (login) that did not originally install the software. If
you try this, you will get errors.

You can make a script that you can double-click and run parmanode that way (see ParmanodL)
instructions for infor about that.

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

Use the update option within the Parmanode software to update. Note, this will not
automatically update the softwre that Parmanode installed for you on your system. To
get newwer versions of updated software, you need to uninstall the particular app, then
reinstall it with the new version of Parmanode - it will then install the newer version
 of the app for you.

## MAKE YOUR OWN PARMANODL

	https://github.com/ArmanTheParman/ParmanodL

ParmanodL is a computer running Linux and Parmanode which can be purchased ready made with
the blockchain syced.

But this is how you make your own.

Download Linux Mint iso.

    cd ~/Downloads
    curl -LO https://mirrors.advancedhosters.com/linuxmint/isos/stable/21.2/linuxmint-21.2-cinnamon-64bit.iso

hash the downloaded file. The command is:

    shasum -a 256 linuxmint-21.2-cinnamon-64bit.iso

You should get:

    116578dda0e03f1421c214acdd66043b586e7afc7474e0796c150ac164a90a2a

Then flash the file to a usb drive - a thumb drive or even a full external SSD drive. The 1Tb
drive you need for the blockchain will do nicely; it's temporary.

Use Balena Etcher to flash the iso file to the drive. This will make it a Linux drive and no longer
readable by a Windows or Mac computer, so when it's finished flashing, ignore the pop-up 
oferring you to format it.

Then, on the computer you wish to install the operating system, figure out how to
boot from the USB. Every computer will be different; Google is your friend here.

You'll then get a Linux boot menu. Choose the OEM install. You'll install the software
as though you were the computer manufacturer, preparing the software for a customer.
All your settings you choose are temporary, so don't stress about what choices you make
during the install.

Once installed, you'll see an icon on the desktop to "ship to end user". Double click it.
Then dismiss the pop up and restart the computer. You'll be asked to remove the USB drive.

This time when the computer boots up, you'll make your computer account and fill in details
that will remain.

Next, make sure you have an internet connection and run the following commands in terminal 
(black icon on the tasbar at the bottom), one after the other, and hit <enter> after each
line. Copy/paste is best:

    sudo apt update -y ; sudo apt install git -y
    cd ~/Desktop ; git clone http://github.com/armantheparman/parmanode.git

The above commands will install git, then use git to download Parmanode to the desktop (this
is the best place for it to live, try not to move it). 

The next commands will create a script which sits on the desktop and you can double click it
to run Parmanode. You'll get a pop up and choose to "run in terminal".

    echo '#!/bin/bash' > ~/Desktop/run_parmanode.sh
    echo "cd ; cd Desktop ; cd parmanode ; ./run_parmanode.sh" >> $HOME/Desktop/run_parmanode.sh
    sudo chmod +x $HOME/Desktop/run_parmanode.sh


