# Parmanode 3.25.6

### Open Source, easy AF Bitcoin node for desktop computers

![Menu](https://parmanode.com/wp-content/uploads/2023/09/parmanode_menu.png)

![OS available](https://parmanode.com/wp-content/uploads/2023/09/Screen-Shot-2023-09-19-at-4.28.57-pm.png)

## Introduction

Parmanode is an automated installation wizard and menu for desktop computers, with the following software (list is growing). You don't have to install all of them! 

Parmanode lets you select what you want to include in your set up:
![Available programs](https://parmanode.com/wp-content/uploads/2023/09/a-1.png)

Parmanode is designed for non-technical users giving them the ability to  download and verify Bitcoin related software, and sync using an external  or internal drive, and also have configuration options presented to them with automation. No manual configuration file editing will be required - Parmanode takes care of all that in the background.

Users only need to read the menu options CAREFULLY, and respond to
the questions - no command line interaction is ever needed. For example, 
from a menu, bitcoin-cli commands are available, pruning can be activated 
and rpcuser/rpcpassword can also be set.

The software also comes with helpful information, including links to various articles on my website, armantheparman.com, so that Bitcoiners keep learning more about Bitcoin and how to be safely self-sovereign.

![Education](https://www.parmanode.com/wp-content/uploads/2023/09/sss.png)

Information on how  to connect various wallets to the node is provided, altough, Parmanode gives options to connect the wallet for the users in the background AUTOMAGICALLY. For example:

![Electrum](https://parmanode.com/wp-content/uploads/2023/09/electrum.png)

The most basic usage of Parmanode would be an internal drive to sync the Bitcoin blockchain, running the latest version of Bitcoin Core, and connecting Sparrow or Specter directly to Bitcoin Core on the same computer. If Electrum is required, then one of the Electrum servers (Fulcrum or electrs) is also required.

While I tried to avoid it, for now, Mac users who wish to use Fulcrum will need to use Docker. Connecting may be problematic, so I recommend for now that Mac users use Bitcoin Core and Sparrow on the same computer, and let Parmanode connect the two. If you want to use Sparrow or Electrum with an Electrum Wallet, the better way would be to use a Linux machine, at least for now.

## Read The Code?

I have added copious comments to the code so that a non-developer can read it in an instructional way and learn what's going on. I expect it shouldn't be that hard to follow. All commands in the code are executable manually in the terminal, so you can experiment and try out things you see.

I suggest using sofware called Visual Studio Code (VSC), as it colour codes everything and makes it easier to follow the syntax. Open the parmanode script folder that you downloaded from GitHub and read the code in VSC software.

It can be a bit of a maze if you don't know where to start. I suggest to start at the "run_parmanode.sh" file and branch out from there. Most guidance is on that page, and more is added as you branch out. The majority of the comments for now are related to installing parmanode, custom functions, and installing Bitcoin Core.

## How to Run/Install

The simplest way to install is to copy and paste the following line into the Linux or Mac terminal...

    curl https://parmanode.com/install.sh | sh

On Macs, to use git (necessary), you may be asked to install the command line developer tools. You will be given the option to do so with a popup window, and you'll need to proceed with it to use git. It takes a few minutes to install.

If you are extra cautious, you can see the installation code first (it's very short), you can type in the above command but omit the "| sh" ending. That will print out the code to the screen.

If you get a fingerprint error/warning when you run the installation command, that's fine, carry on.

From then on, to run Parmanode, you can double click the run_parmanode.sh file on the desktop. If you get a popup, choose to "run in terminal". 

Alternatively you can open terminal, navigate to the right directory with 

    cd Desktop/parmanode 

Then run the program:

    ./run_parmanode.sh 

Parmanode is not designed to be run by a user (login) that did not originally install the software. If you try this, you will get errors.

## A Note About Superuser

When the program runs, you will be asked at some point for a password - this is your 
computer's "sudo" or login password, and is necessary for Parmanode to access system 
functions like mounting drives.

Please be aware, you cannot run the program as the root user. 

## Run on a VPS

You can install Parmanode on a virtual private server but be aware the data requirement (for Bitcoin Core) can get expensive unless you run it pruned. Remember, you can't run as root.

## A Warning About SSH

You can access the computer with parmanode (ParmanodL) using SSH, but be aware, some apps are designed to work in a graphical environment. Parmanode might cause pop ups windows such as wallets, but you won't see them via SSH. It's fine to access by SSH, but just be mindful of this.

## Instructions to Upgrade

Use the update option within the Parmanode software to update. 

Note, this will NOT automatically update the software that Parmanode installed for you on your system. 

To get newer versions of updated apps, you need to uninstall the particular app, (you should use Parmanode remove tools), then reinstall it (with the new version of Parmanode) - it will then install the newer version of the app for you.

## Make Your Own "PARMANODL"

    https://github.com/ArmanTheParman/ParmanodL 

ParmanodL is a computer running Linux and Parmanode which can be purchased ready made with
the blockchain syced.

But this is how you make your own:

Download Linux Mint iso.

    cd ~/Downloads curl -LO 

    https://mirrors.advancedhosters.com/linuxmint/isos/stable/21.2/linuxmint-21.2-cinnamon-64bit.iso

Hash the downloaded file (to be sure it's safe). The command is:

    shasum -a 256 ~/Downloads/linuxmint-21.2-cinnamon-64bit.iso 

You should get:

    116578dda0e03f1421c214acdd66043b586e7afc7474e0796c150ac164a90a2a 

Then flash the file to a USB drive (a thumb drive or even a full external SSD drive). The 1Tb drive you need for the blockchain will do nicely; you can use it for this and then use if for the blockchain data next.

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

Next, make sure you have an internet connection and run the following commands in terminal  (black icon on the tasbar at the bottom), one after the other, and hit  after each line. Copy/paste is best:

    curl https://parmanode.com/install.sh | sh

The above command will install git, then use git to download Parmanode and create a Desktop icon for you to run the program.
