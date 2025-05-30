return 0
########################################################################################
# This is the install script kept at
# https://parmanode.com/install_4mac2.sh - the URL is easier to remember and shorter 
# than if keeping it on Github.


########################################################################################
#!/bin/sh

if [ -d $HOME/parman_programs/parmanode ] ; then
clear
#update parmanode if it exists...
if ! git config --global user.email ; then git config --global user.email sample@parmanode.com ; fi
if ! git config --global user.name ; then git config --global user.name Parman ; fi
cd $HOME/parman_programs/parmanode && git config pull.rebase false && git pull >$dn 2>&1

#make desktop text document...
if [ ! -e $HOME/Desktop/run_parmanode.txt ] ; then

touch $HOME/.zshrc >$dn 2>&1

if ! grep -q "run_parmanode.sh" $HOME/.zshrc ; then
echo "#Added by Parmanode...
function rp { cd $HOME/parman_programs/parmanode ; ./run_parmanode.sh \$@ ; }
" | sudo tee -a $HOME/.zshrc >$dn 2>&1
fi

cat > $HOME/Desktop/run_parmanode.txt << 'EOF'
To run Parmanode, simply open the terminal and type:

rp
then <enter>

'rp' stands for 'run Parmanode'. Alternatively, you can manually type 
out the 'rp' function...

cd $HOME/parman_programs/parmanode/
<enter>
./run_parmanode.sh
<enter>

NOTE: rp will not work in the window you used to install Parmanode.
Close it, open a new one, and then rp will work.

You can delete this file once you've absorbed the information.
EOF
clear
echo "See new text document on Desktop."
fi

#no further changes needed.
echo "Parmnode already downloaded."
exit
fi

########################################################################################
#Check mac version 10.9 or later...

export MacOSVersion=$(sw_vers | grep ProductVersion | awk '{print $ 2}')
export MacOSVersion_major=$(sw_vers | grep ProductVersion | cut -d \. -f 1 | grep -Eo '[0-9]+$')
export MacOSVersion_minor=$(sw_vers | grep ProductVersion | cut -d \. -f 2)
export MacOSVersion_patch=$(sw_vers | grep ProductVersion | cut -d \. -f 3)

if [[ ($MacOSVersion_major -lt 10) || ($MacOSVersion_major == 10 && $MacOSVersion_major -lt 9) ]] ; then
clear
echo "
########################################################################################

    Sorry, you need MacOS version 10.9 or later to use Parmanode.

########################################################################################
    Hit <enter> to continue.
"
read
exit 0
fi

while true ; do #loop 1
if xcode-select -p >$dn 2>&1 ; then break ; fi

#Install cldts
clear
sudo -k
echo "
########################################################################################
   
   Command Line Developer Tools is needed.

   There will be a pop up question which you'll need to respond to (It may actually
   be minimised, so look at the task bar below if you don't see it). The install
   estimate will initially say some HOURS, but ignore that, it's wrong.

   Once Command Line Tools have successfully installed, enter your computer password,
   then <enter> to continue.

   Hit <enter> ONLY after the pop up has finished installeding, and not before, or 
   your computer will melt.
 
   If you want to abandon, you can hit <control> c now.

####################################################################################### 
"
xcode-select --install

sudo sleep 0.1break
done #ends loop 1

########################################################################################
#Installing Parmanode

mkdir -p $HOME/parman_programs >$dn 2>&1 
cd $HOME/parman_programs
git clone https://github.com/armantheparman/parmanode.git

if ! grep -q "run_parmanode.sh" $HOME/.zshrc ; then
echo "#Added by Parmanode...
function rp { cd $HOME/parman_programs/parmanode ; ./run_parmanode.sh \$@ ; }
" | sudo tee -a $HOME/.zshrc >$dn 2>&1
fi

#make desktop clickable icon...
cat > $HOME/Desktop/run_parmanode.txt << 'EOF'
To run Parmanode, simply open a new Terminal window and type:

rp
then <enter>

'rp' stands for 'run Parmanode'. Alternatively, you can manually type 
out the 'rp' function...

cd $HOME/parman_programs/parmanode/
<enter>
./run_parmanode.sh
<enter>

NOTE: rp will not work in the window you used to install Parmanode.
Close it, open a NEW one, and then rp will work.

You can delete this file once you've absorbed the information.
EOF
clear

if ! grep -q "#Added by Parmanode..." $HOME/.zshrc >$dn 2>&1 ; then
echo "#Added by Parmanode..." | tee -a $HOME/.zshrc >$dn 2>&1 
echo 'function rp { cd $HOME/parman_programs/parmanode ; ./run_parmanode.sh $@ ; }' | tee -a $HOME/.zshrc >$dn 2>&1
fi

echo "
########################################################################################

    There should be an icon on the desktop for you, \"run_parmanode.txt\" which is
    a text document reminding you about the following instructions on how to run 
    Parmanode:

    Simply open a new Terminal window (close this one first) and type:

    rp
    then <enter>

    Enjoy.

########################################################################################
"
exit
