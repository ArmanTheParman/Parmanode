This is a simple python script that attempts to unlock a locked electrum wallet file.

It's ideal to run this only on an air-gapped computer, but this is second best, 
using a Docker container (switch off internet when you run it.)

You should first install ParmaBox in the container, and from within the docker container, 
run the install_electrum.pip.sh script. If get errors, read the script and figure out
what went wrong, the libraries that need to be installed are in that file.

Then move your wallet file to the container by the mounted "shared" directory:
/home/$USER/parmanode/parmabox/

$USER is a variable that gets your username that you've logged in with.

Then from within the container, navigate to

cd /home/parman_programs/parmanode/src/ParmaWalelt/electrum_cracker/

and run the script...

python3 crack.py

The program will promtp you for information.

If the wallet gets cracked the password will be written to a file. Make a note of
the contents then delete the file.