# Electrum Wallet Cracker - what it does

This is a simple python script that attempts to unlock a locked electrum wallet file.

Using custom strings and/or a text file of words, EWC can iterate through all
possible combinations. You can set the maximum number of positions to limit the
search time. For example, if you set it to 3, and you included the strings "a",
"HELLO", and "foo", it will search...

### one position...
a
HELLO
foo

### two positions...
aHELLO
afoo
HELLOa
HELLOfoo
fooa
fooHELLO

### three positions...

aHELLOfoo
afooHELLO
HELLOafoo
HELLOfooa
fooHELLOa
fooaHELLO

If you had a string with all lower case letters, and you knew it was say 7 characters long,
you would enter all the possible lowercase letters (you could exclude some you know it
wouldn't be, eg if you know there isn't an 'x' don't type it in)...

a,b,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,y,z  (no x included)

then choose 7 for the position number, and let it work.

You could also prepare a text file and include all those letters, and any names or symbols,
one per line, and enter the file path when prompted.

EWC will combine manually entered strings and the file strings into one list data structure,
and then iterate possible combinations form that data list.


# Installation

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