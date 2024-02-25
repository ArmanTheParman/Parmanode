# Parmanode 3.31.0

### Open Source, easy AF Bitcoin node for Desktop Computers and Pi

<center><img src="https://parmanode.com/wp-content/uploads/2023/09/collection.png" alt="AI pic" style="width:100%;">
<br>
<br>

<img src="https://parmanode.com/wp-content/uploads/2024/02/Screen-Shot-2024-02-14-at-5.20.47-pm.png" alt="Main Menu" style="width:50%;">
<br>
<img src="https://parmanode.com/wp-content/uploads/2023/09/Screen-Shot-2023-09-19-at-4.28.57-pm.png" alt="OS" style="width:30%;" >

<p><a href="https://armantheparman.com/buyparmanodl">LINK TO DETAILED INSTALLATION GUIDE</a></p>
<p><a href="https://parmanode.com/install/">BUY A PRE-BUILT PARMANODL</a></p>
<p><a href="http://armantheparman.com/mentorship">TOO HARD; TEACH ME</a></p>
</center>

## Introduction

Parmanode is an automated installation wizard and menu for desktop computers, with the following software (list is growing). You don't have to install all of them! 

Parmanode lets you select what you want to include in your set up:
<br>
<center><img src="https://parmanode.com/wp-content/uploads/2024/02/install-menu.png" alt="Install Menu" style="width:50%;">
<br>
<img src="https://parmanode.com/wp-content/uploads/2024/02/Screen-Shot-2024-02-14-at-5.16.44-pm.png" alt="Node install menu" style="width:50%;">
<img src="https://parmanode.com/wp-content/uploads/2024/02/pic1-3.png" alt="Wallet install menu" style="width:50%;">
<img src="https://parmanode.com/wp-content/uploads/2024/02/Screen-Shot-2024-02-14-at-5.19.34-pm.png" alt="Other install menu" style="width:50%;">
</center>
<br>
Parmanode is designed for non-technical users giving them the ability to  download and verify Bitcoin related software, and sync using an external  or internal drive, and also have configuration options presented to them with automation. No manual configuration file editing will be required - Parmanode takes care of all that in the background.<br>
<center><img src="https://parmanode.com/wp-content/uploads/2024/02/pic1-6.png" alt="compiling" style="width:50%;">
</center><br>
Users only need to read the menu options CAREFULLY, and respond to
the questions - no command line interaction is ever needed. For example, 
from a menu, bitcoin-cli commands are available, pruning can be activated 
and rpcuser/rpcpassword can also be set.<br>

The software also comes with helpful information, including links to various articles on my website, armantheparman.com, so that Bitcoiners keep learning more about Bitcoin and how to be safely self-sovereign.<br>
<center>
<img src="https://parmanode.com/wp-content/uploads/2024/02/Screen-Shot-2024-02-14-at-5.25.16-pm.png" alt="Education" style="width:50%;">
</center><br>

Information on how  to connect various wallets to the node is provided, altough, Parmanode gives options to connect the wallet for the users in the background AUTOMAGICALLY. For example:<br>

<center>
<img src="https://parmanode.com/wp-content/uploads/2024/02/pic1-7.png" alt="electrs" style="width:50%;">
</center><br>

The most basic usage of Parmanode would be an internal drive to sync the Bitcoin blockchain, running the latest version of Bitcoin Core, and connecting Sparrow or Specter directly to Bitcoin Core on the same computer. If Electrum is required, then one of the Electrum servers (Fulcrum or electrs) is also required.

While I tried to avoid it, for now, Mac users who wish to use Fulcrum will need to use Docker. Connecting may be problematic, so I recommend for now that Mac users use Bitcoin Core and Sparrow on the same computer, and let Parmanode connect the two. If you want to use Sparrow or Electrum with an Electrum Wallet, the better way would be to use a Linux machine, at least for now.

## Read The Code?

I have added copious comments to the code so that a non-developer can read it in an instructional way and learn what's going on. I expect it shouldn't be that hard to follow. All commands in the code are executable manually in the terminal, so you can experiment and try out things you see.
<br>
I suggest using sofware called Visual Studio Code (VSC), as it colour codes everything and makes it easier to follow the syntax. Open the Parmanode script folder (~/parman_programs/parmanode/) and read the code in VSC software.
<br>
It can be a bit of a maze if you don't know where to start. I suggest to start at the "run_parmanode.sh" file and branch out from there. Some guidance is on that page, and more is added as you branch out. The majority of the comments for now are related to installing Parmanode, custom functions, and installing Bitcoin Core.
<br>
## How to Run/Install

The simplest way to install is to copy and paste the following line into the Linux or Mac terminal...

    curl https://parmanode.com/install.sh | sh

On Macs, to use git (necessary), you may be asked to install the command line developer tools. You will be given the option to do so with a popup window, and you'll need to proceed with it to use git. It takes a few minutes to install.

On some barebones Linux systems, curl may not be installed and the above command won't work. You'll need to install curl first...

    sudo apt-get install curl

VIDEO DEMONSTRATION OF INSTALLATION...

<iframe width="560" height="315" src="https://www.youtube.com/embed/3KkCggxop0Y" frameborder="0" allowfullscreen></iframe>

If you are extra cautious, you can see the installation code first (it's very short), you can type in the above command but omit the "| sh" ending. That will print out the code to the screen.

If you get a fingerprint error/warning when you run the installation command, that's fine, carry on.

From then on, to run Parmanode, Linux users can double click the Parmanode icon on the desktop. If you get a pop-up, select "execute in terminal". If this fails (it will on some Linux systems) see below for alternative.

Mac users will get a "run_parmanode.txt" file, containing instructions; text to cut and paste into terminal to run. 

Alternatively, if the installation went smoothly, you can just open terminal and type the follwing command, then <enter>:

    rp

Alternatively you can take a more granular approach with these two commands (which the above rp command does on its own):

    cd ~/parman_programs/parmanode 

    ./run_parmanode.sh

Parmanode is not designed to be run by a user (ie login name) that did not originally install the software. If you try this, you will get errors.

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

ParmanodL is a computer running Linux and Parmanode which can be purchased ready made with the blockchain syced (contact Parman for info).

Or you can make your own. On a Linux computer, run this line in terminal:

    curl https://parmanode.com/get_parmanodl_installer | sh

You just follow the instructions and the installer will flash a microSD card for you for your Pi - all the downloading, verifying, flashing, it's automatic.

If for some reason, the above procedure fails, you can get a pre-made Rasbperry Pi (64 bit) image file of ParmanodL OS in two different ways ( the file is too big to host on GitHub or a public server I'm afraid).

ONE: You can use the Tor Browser to access my private server and download it from there. Verify the download with the hash (see below for how).

    https://7zatnd4wode263mlx5tmvvbyon4ej64noftfp3lloayhiwbogm63kdad.onion:7777/index.html

TWO: From this torrent. Torrents are links to the file on a network of shared computers. When you download the file, if you leave it in place, and leave the torrent software running, then other people can download from you too; sharing is caring. 

You'll need a program like qBitTorrent for Mac or Linux. For Linux, make sure to make the qBitTorrent file executable with

    sudo chmod +x /path/to/AppImage

Once you download the ParmanodL image file, check the sha256 hash. The command for that is:

    shasum -a 256 /path/to/the/image/file

I hope I don't have to explain that you replace /path/to/the/image/file with the actual path of the image file! 

You should get:

    53d3d918779346eff9d2137786ffe5d5da57ef856caad8470108bc852565f0fd

Make sure you don't just trust the comments inside the torrent file with its printed hash. Compare it with what is above as well. Then if you hash output matches, you'll know you're really getting the file I am wanting to deliver, and not be a victim of a man-in-the-middle attack.

Then flash the image to a microSD card using Balena Etcher, then stick it in the Pi and switch it on. Access the Pi as a traditional desktop computer, or via ssh with

    ssh parman@parmanodl.locl      
    user=parman ; password=parmanodl

Pay attention to the password. When you log in for the first time, you'll be forced to change the password. The way the software behavious is odd, be warned. If using a graphical user interface (ie attached monitor and keyboard/mouse to the Pi), you'll be asked for the default password (parmanodl). You will then be told to make a new password - BUT WITHOUT EXPLANATION, IT'S ACTUALLY WAITING FOR THE SAME DEFAULT PASSWORD FIRST. After that, you put a new password,  then repeat it to confirm. Sorry about that, blame the developers of Raspberry Pi OS, that bit is mostly out of my control. 

But to make your own ParmanodL with a regular 64-bit (x86-64 or AMD) Linux machine (Desktop or Laptop), you can download the official Linux Mint ISO by running this command (the following is a very long single line of text):

    cd ~/Downloads && curl -LO https://mirrors.advancedhosters.com/linuxmint/isos/stable/21.2/linuxmint-21.2-cinnamon-64bit.iso

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

<br>
<center>
<img src="https://parmanode.com/wp-content/uploads/2023/09/Screen-Shot-2023-09-22-at-4.15.35-pm.png" alt="AI pic" style="width:100%;">

