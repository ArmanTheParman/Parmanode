#!/bin/bash

# source all the  modules.

	for file in ./**/*.sh
	do
	source $file
	done


# Check OS function and store in variable for later.

	OS=$(which_os)

# Make sure Linux computer. 

	if [[ $OS != "linux" ]] ; then echo "Wrong operating system. This version of Parmanode \
	is for Linux only. Aborting ... " ; enter_continue ; exit 0 ; fi
	# enter_continue is a custom echo function with a read command for confirmation.

# set "trap" conditions; currently makes sure user's terminal reverts to default colours.

	clean_exit 

# Debug - delete before release.

	debug_point "Pause here to check for error output before clear screen." 


#Begin program:

	set_terminal # custom function for screen size and colour.
	intro
	sudo_check
	gpg_check
	menu_startup

exit 0
# CHECK CONFIG FOR DRIVE CHOICE, AND OFFER USER TO SWAP CHOICE.

function change_drive_selection {
source $HOME/.parmanode/parmanode.conf

while true
do
set_terminal
if [[ -z "$drive" ]] ; then echo "No drive choice. Something went wrong. Please re-install Parmanande." ; fi
echo "
########################################################################################
    
    You have chosen an $drive drive to run the Bitcoin blockchain data.

                            (a) to accept and continue

                            (c) to change

########################################################################################
"
choose "xpq"
read choice

    case $choice in

    a|A)        #user accepts previous drive choice
        delete_line "$HOME/.parmanode/parmanode.conf" "drive="  >/dev/null  #clean up potential multiple entries before writing.
        echo "drive=$drive" >> "$HOME/.parmanode/parmanode.conf" 2>/dev/null
        break ;;
    c|C)        #user wishes to change previous drive choice
        set_terminal
        echo "Please choose internal (i) or external (e), then <enter>.
        "
        read drive_swap_choice
        #check for valid choice and rename value.
            if [[ $drive_swap_choice != "i" && $drive_swap_choice != "e" ]] ; then invalid ; continue ; fi
            if [[ $drive_swap_choice == "i" ]] ; then drive_swap_choice="internal" ; fi # saves user from typing "internal" and reduce risk of typo in value.
            if [[ $drive_swap_choice == "e" ]] ; then drive_swap_choice="external" ; fi
            if [[ $drive_swap_choice == "$drive" ]] # if user ended up choosing what they had already chose before.
		    then
			echo "No change made, continuing. Hit <enter>." ; read ; break
		    else
			delete_line "$HOME/.parmanode/parmanode.conf" "drive="  >/dev/null  #clean up potential multiple entries before writing.
			echo "drive=$drive_swap_choice" >> "$HOME/.parmanode/parmanode.conf" 2>/dev/null
			source $HOME/.parmanode/parmanode.conf #updates drive variable for this shell session.
            fi
            ;;
        p|P)
        return 1 ;;
        q|Q|quit|QUIT)
        exit 0 ;;
        *)
        invalid
        ;;
        esac
done
return 0
}
function connect_wallet_info {
while true
do
set_terminal_wide
echo "
##############################################################################################################
                                    
                                    Bitcoin Wallet Connection Info

    To connect your wallet, you need to first wait for the Bitcoin blockchain to finish syncing. You can 
    inspect the debug.log file (access from Parmanode Bitcoin Core menu) to check its progress in real 
    time. Any errors with Bitcoin Core will show up here as well.

                            s)          Sparrow Bitcoin Wallet

                            e)          Electrum Desktop Wallet

                            sd)         Specter Desktop Wallet

##############################################################################################################
"
choose "xpq"
read choice
set_terminal_wide
case $choice in
    s|S)
    sparrow_wallet_info
    ;;

    e|E)
    electrum_wallet_info
    ;;

    sd|SD|sD|Sd)
    specter_wallet_info
    ;;

    p)
    return 0 ;;

    q|Q|quit|QUIT)
    exit 0
    ;;

    *)
    invalid
    break
    ;;

esac
done
return 0
}



function sparrow_wallet_info {
echo "
##############################################################################################################

                                           SPARROW BITCOIN WALLET

    Unfortunately, for now, this wallet needs to be on the same computer as the Parmanode software.
     
    In the Sparrow Server settings, use 127.0.0.1 as the IP address and 8332 as the port. 
   
    The default connection method in Sparrow uses a cookie. This should work. If it doesn't, you can 
    change to the \"User/Pass\" method, but you do need to enter a rpcuser and rpcpassword in the 
    bitcoin.conf file (accessible through Parmanode menu). You then have to restart bitcoind.
 
    If you ever decided to install Fulcrum (an Electrum server) on your Parmanode, then Sparrow will 
    be able to connect to that instead of directly to Bitcoin Core. If this is enabled, you are not 
    as limited, and can connect from another computer. Fulcrum will be available for Parmanode in 
    later versions. Tor will also be available later, allowing you to connect to your Fulcrum
    Parmanode server from outsite your home network.

##############################################################################################################

"
enter_continue
return 0
}

function electrum_wallet_info {
echo "
##############################################################################################################

                                       ELECTRUM DESKTOP WALLET

    Note that a connection with Electrum Wallet is not possible until Fulcrum Server is installed.

    Once Fulcrum is installed, you can connect to it from your Electrum Wallet with the following steps:

        1) Go to Electrum Network settings (from menu or the circle on the bottom right)
	
        2) Uncheck \"Select server automatically\"
	
        3) Type the IP address of the computer that runs Parmanode.
                You can find this by typing \"ifconfig | grep broadcast\" in your terminal window. 
                You'll see it as one of the outputs. Typically something like 192.168.0.150

        4) If the wallet and Parmanode are on the same computer, you can type either
            \"localhost\" or \"127.0.0.1\"
	    
        5) If your wallet is not on the same computer as Parmanode, you need to type the IP address
           of the Parmanode computer in your wallet.

        6) You also MUST type in the port. The default value is 50002. An example would look like:

                                         127.0.0.1:50002
    
    At the top of the network settings window, you will see \"connected to x nodes\". If x is not equal
    to 1, you should try to fix that (f).

    Instructions to connect to Tor soon.

##############################################################################################################

Type (f) for instructions to connect to only one server, or hit <enter> alone to return.

"
read choice
if [[ $choice == "f" ]] ; then electrum_one_server ; fi
return 0

}

function electrum_one_server {
echo "
##############################################################################################################

                                  Connect Electrum to One Server Only

    Unfortunately, this is harder than it needs to be.

    You MUST open a Wallet in Electrum at least once. Even a dummy/discardable wallet will do. This will
    populate a default config file. Then exit Electrum all together. Shut it down.

    Then navigate to $HOME/.electrum

    Open the file \"config\". You could open via terminal with \"nano config\"

    Modify the line that has \"oneserver\" in it, from \"false\" to \"true\", and do not change the syntax.

    Save and exit. You can then open Electrum Wallet, check the network settings and see that you are only
    connected to one node.

##############################################################################################################
"
enter_continue
return 0
}

function specter_wallet_info {
echo "
##############################################################################################################
                        
                                        Specter Desktop Wallet:

    Newer versions of Specter now allow you to connect not only to Bitcoin Core directly, but to an 
    Electrum (Fulcrum) server as well. 
    
    You need to name the connection to proceed. It's not yet tested, but if it insists on a username and 
    password, you need to modify the bitcoin.conf file (see the Parmanode Bitcoin menu to access) and 
    add it in like this:

                                         rpcuser=my_user_name
                                        
                                         rpcpassword=my_password 
    
    If you make changes to the config file, you need to restart Bitcoin for the changes to take effect.

    In Specter Wallet, you'll see http://localhost - leave as is, but if that doesn't work, try 
    http://127.0.0.1, then finally, click \"Connect\"

##############################################################################################################
"
enter_continue
return 0

}
function install_bitcoin {

set_terminal

install_check "bitcoin-start" 
    #first check if Bitcoin has been installed
    return_value="$?"
    if [[ $return_value = "1" ]] ; then return 1 ; fi       #Bitcoin already installed


change_drive_selection
    # abort bitoin installation if return 1
    if [[ $? == 1 ]] ; then return 1 ; fi



# set $prune_value. Doing this now as it is related to 
# the drive choice. Use variable later for setting bitcoin.conf

prune_choice 
    # make bitcoin directories in appropriate locations

make_bitcoin_directories $drive         
    # external or internal argument
    # installed entry made when parmanode/bitcoin directory made.

download_bitcoin

#setup bitcoin.conf
debug_point "about to enter make bitcoin conf"
make_bitcoin_conf
    if  [ $? -ne 0 ]
        then return 1
    fi

#make a script that service file will use
make_mount_check_script
debug_point "made mount check script."

#make service file
make_bitcoind_service_file

set_terminal

echo "
########################################################################################
    
                                    SUCCESS !!!

    Bitcoin Core will begin syncing after a reboot, or you can start Bitcoin Core 
    from the Parmanode menu.

    You can also access Bitcoin functions from the Parmanode menu.
    

########################################################################################
" && installed_config_add "bitcoin-end"
enter_continue
return 0 
}

function download_bitcoin {
    #downloads
cd $HOME/parmanode/bitcoin

set_terminal
echo "
########################################################################################
    
    The current version of Bitcoin Core that will be installed is 24.0.1

    The pgp key that will be used to verify the SHA256 file list is:

                Michael Ford: E777299FC265DD04793070EB944D35F9AC3DB76A 
    
    The downloaded file will then be hased (SHA256) and compared to the hash result 
    provided by Michael Ford.
    
    You may wish to learn how to do this yourself...

            - The file containing the hashes can be found at 
              /home/$(whoami)/parmanode/bitcoin/SHA256SUMS. 
            - The corresponding signature of that file is called SHA256SUMS.asc
            - You can then hash the bitcoin .tar.gz file using this command:
                   
                   shasum -a 256 bitcoin-24.0.1-x86_64-linux-gnu.tar.gz

            - After a few seconds you'll get a hash. Compare it to the one listed 
              by Michael Ford.

    Hit <enter> to keep reading.

########################################################################################
"
read ; set_terminal
echo "
########################################################################################
    
            - Next, if you don't feel like trusting Michael Ford is sufficiently 
              safe, you can import the public keys of anyone else who has signed the 
              file.

    What actually do these signers do?

    The take the code, written in programming language, and compile it (convert it
    to machine code, ie binary) then zip the result. This produces one file that they 
    hash.If there is any tampering of the code, the hash produced will change. If many
    people who read the code are providing the same hash, we can be confident sure 
    there hasn't been any funny business between the time they check to when you got 
    your hands on a copy.

    They then digitally sign the document that contains the hash that they vouch for. 
    The way digital signatures work is fascinating and worth learning about. You don't 
    have to be a cryptogrphy PhD to get the gist of it. It is the basis of how Bitcoin
    transactions work, and how nodes verify transactions.

    For more information on PGP, I have detailed guides:

    https://armantheparman.com/gpg-articles/

########################################################################################

Hit <enter> to continue." # don't change
echo ""
#    Do not use "enter_continue" here. See next lines for explanation.

read #using custom function "enter_continue" here produced a strange error I don't 
     #understand. Somehow the read command inside the function was reciving input, I
     #think from the calling function, maybe, and the code proceeds to download (next
     #line) without any user input to continue."

set_terminal ; echo "Downloading Bitcoin files to $HOME/parmanode/bitcoin ..."
wget  https://bitcoincore.org/bin/bitcoin-core-24.0.1/SHA256SUMS 
wget  https://bitcoincore.org/bin/bitcoin-core-24.0.1/SHA256SUMS.asc 
wget  https://bitcoincore.org/bin/bitcoin-core-24.0.1/bitcoin-24.0.1-x86_64-linux-gnu.tar.gz
sha256sum --ignore-missing --check SHA256SUMS

set_terminal

#gpg check

gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys E777299FC265DD04793070EB944D35F9AC3DB76A

    if gpg --verify SHA256SUMS.asc 2>&1 | grep -q "Good" 
    then
        echo "GPG verification of the SHA256SUMS file passed. "
        echo "Continuing with instalation."
        enter_continue
    else 
        echo "GPG verification failed. Aborting." 
        enter_continue
        exit 1
    fi
#unpack Bitcoin core:

mkdir $HOME/.parmanode/temp/ >/dev/null 2>&1
tar -xf bitcoin-* -C $HOME/.parmanode/temp/ >/dev/null  2>&1

#move bitcoin program files to new directory.

mv $HOME/.parmanode/temp/b*/* $HOME/parmanode/bitcoin/

#delete sample bitcoin.conf to avoid confusion.

rm $HOME/parmanode/bitcoin/bitcoin.conf 

#"installs" bitcoin and sets to writing to only root for security. Read/execute for group and others.
sudo install -m 0755 -o root -g root -t /usr/local/bin $HOME/parmanode/bitcoin/bin/*

sudo rm -rf $HOME/parmanode/bitcoin/bin
debug_point "debugging..."
return 0      # abort bitoin installation if return 1
}
function make_backup_dot_bitcoin {
                                        # It is not known how many backups there are so a
                                        # loop is needed.
prefix="$HOME/.bitcoin_backup_"
counter=0
final_directory="$prefix$counter"       # The aim is to produce a backup directory named 
                                        #.bitcoin_backup_ followed by an integer.

while [ -d "$final_directory" ]         # counts the number of backups that exist with
                                        # this numbering format.
do
    counter = $((counter + 1))
    final_directory="$prefix$counter"
done

mv $HOME/.bitcoin "${final_directory}" >/dev/null 2>&1

echo "Moved $HOME/.bitcoin to $final_directory"
enter_continue
return 0
}function make_bitcoin_conf {
#Parmanode defualt config settings. Can be changed.
#Create a bitcoin.conf file in data directory.
#Overrides any existing file named bitcoin.conf
set_terminal``


if [[ -f $HOME/.bitcoin/bitcoin.conf ]]
	then 
	    set_terminal ; echo "The bitcoin.conf file already exists. Hit (o) to overwrite, or (a) to abort the installation."
		read choice
		while true ; do
			if [[ $choice == "a" ]] ; then return 1 ; fi
			if [[ $choice == "o" ]] ; then break ; fi
			echo ""
			invlalid
		done
	fi

echo "
server=1
txindex=1
blockfilterindex=1
daemon=1
rpcport=8332

rpcbind=127.0.0.1
rpcbind=172.17.0.2
rpcallowip=127.0.0.1
rpcallowip=172.17.0.0/16" > $HOME/.bitcoin/bitcoin.conf

apply_prune_bitcoin.conf

return 0
}

########################################################################################

function apply_prune_bitcoin.conf {

#source prune value from parmanode.conf

source $HOME/.parmanode/parmanode.conf

#check if prune_value set. If not, calls function to set it. 
if [[ -z ${prune_value} ]] ; then echo "Prune choice not detected. Neets to be set." ; enter_continue ; prune_choice ; fi

#cannot have prune 0 with txindex and blockfilterindex.

if [[ $prune_value != "0" ]]
then
	delete_line "$HOME/.bitcoin/bitcoin.conf" "txindex=1"
	delete_line "$HOME/.bitcoin/bitcoin.conf" "blockfilterindex=1"
fi

if [[ $prune_value == "0" ]]
then
	#delete all first, in case of multiple occurrances.
	delete_line "$HOME/.bitcoin/bitcoin.conf" "txindex=1"
	delete_line "$HOME/.bitcoin/bitcoin.conf" "blockfilterindex=1"

	echo "txindex=1" >> $HOME/.bitcoin/bitcoin.conf
	echo "blockfilterindex=1" >> $HOME/.bitcoin/bitcoin.conf
fi

return 0
}

function make_bitcoin_directories {
drive=$1


#has the bitcoin directory on parmanode been made? If not, make it.
    parmanode_bitcoin_directory             
                                        


# If external drive - create necessary directories 

external_drive_directories              
    # calls format_choice
    # calls delete_dot_bitcoin_directory (+/- make_backup_dot_bitcoin_director)
    # calls set_dot_bitcoin_symlink
                                                                              
                                   
#Internal drive - create directories, and back up if existing.
internal_drive_directories
    # check if drive is internal
    # give user options if .bitcoin exists
    # option to call make_bakcup_dot_bitcoin
    # abort bitoin installation if return 1
    if [[ $? == 1 ]] ; then return ; fi 
return 0
}

function parmanode_bitcoin_directory {

if [[ -d $HOME/parmanode/bitcoin ]] 
then 
            rm -rf $HOME/parmanode/bitcoin/* > /dev/null 2>&1
else
            mkdir $HOME/parmanode/bitcoin > /dev/null 2>&1
fi

installed_config_add "bitcoin-start"
#First significant install "change" made to drive

return 0
}


########################################################################################

function external_drive_directories {
debug_point "entered external drive directories"
if [[ $drive == "external" ]]
    then
    format_choice                           # a chance to format drive again if not done before.
                                            # if .bitcoin exists, and, isn't a symlink, user 
                                            # to decide to wipe or back up.
                                            # create symlink later. Double check.
delete_dot_bitcoin_directory                                        
    debug_point "about to make symlink"
set_dot_bitcoin_symlink


fi
return 0
}

########################################################################################

function internal_drive_directories {

if [[ $drive == "internal" ]]
then true
else return 1
fi

# If .bitcoin directory exists, decide what to do with it.
# If it doesn't exists, do nothing, running bitcoind will create it automatically.

if [[ -d $HOME/.bitcoin ]]
then 

while true #menu loop
do
set_terminal
echo "
########################################################################################

           $HOME/.bitcoin (Bitcoin data directory) already exists

    Would you like to:

            (d)         Start fresh and delete the files/directories contained 
                        within

            (yolo)      Use the existing .bitcoin data directory (be careful)

            (b)         Make a backup copy as ".bitcoin_backup", and start fresh

    If using the existing directory (yolo), be aware Parmanode might make changes 
    to its contents, and you could get unexpected behaviour.       

########################################################################################
"     
choose "xq"

read choice

set_terminal

case $choice in

    d|D) #delete
        rm -rf $HOME/.bitcoin/
        echo ".bitcoin directory deleted."
        enter_continue
        break
        ;;

    yolo|YOLO) #use existing .bitcoin directory and contents
        echo "
        Using exiting .bitcoin directory"
        enter_continue
        break
        ;;

    b|B) #back up directory
        make_backup_dot_bitcoin                 #original directory deleted by a "move"
        break
        ;;

    q|Q|quit|QUIT)
        exit 0
        ;;
        
    *)
        invalid
        continue ;;
esac

done 
else
    mkdir $HOME/.bitcoin >/dev/null 2>&1
fi 
return 0
}



function format_choice {
set_terminal
echo "
########################################################################################

                    Format drive? (y) (n)
                
                    You don't have to if you've already done this.

########################################################################################
"
choose "xq"
read choice
if [[ $choice == "y" ]] ; then format_ext_drive ; set_terminal ; fi
return 0
}

########################################################################################



function delete_dot_bitcoin_directory {                        
#.bitcoin will be deleted if it exists and is not a symlink.

if [[ -d "$HOME/.bitcoin" && ! -L "$HOME/.bitcoin" ]]        
then
debug_point " .bitcoin proper directory exists"
while true
do
set_terminal
echo "
########################################################################################

    The directory:
    
                $HOME/.bitcoin
    
    currently already exists on your internal drive. It has a size of: 
    
                $(du -sh $HOME/.bitcoin | cut -f1)

    Even though you are using an external drive for the Bitcoin data directory,
    this internal drive's directory is needed to "direct traffic" to the external 
    drive by a symlink, also known as a "shorcut" to Windows users.

    To continue with an external drive, the .bitcoin directory needs to either be 
                        
                        deleted (d)  ----> reckless?

                        backed up (b) and renamed to .bitcoin_backup. 

    A symlink to the external drive will be created in its place and named
    $HOME/.bitcoin.

    Note that the \".\" in front of bitcoin means it's a hidden directory.

    The backup you make can be deleted later. If you know what you're doing, you can 
    move the backup directory to the original location to use that copy of the 
    blockchain data should you ever need.

########################################################################################
"
choose "xq"
read choice
set_terminal

    case $choice in
        d)                                      #User chooses to delete existing data directory.
            sudo rm -rf $HOME/.bitcoin 
            break
            ;;
        b)                                      #User chooses to back up existing data directory, and original is deleted.
            make_backup_dot_bitcoin             
            break
            ;;
        *)
            invalid
            ;;

        q | quit | Q)
            exit 0
            ;;
        esac

done 
else
    true # nothing do do, there should be no .bitcoin in the HOME directory. Will make symlink later.
fi     


return 0
}



function set_dot_bitcoin_symlink {
debug_point "entered set dot bitcoin symlink"
set_terminal

#check there is a drive mounted, then make .bitcoin directory on external drive.
while true
do
echo "
########################################################################################

                             Preparing External Drive

    
    Please make sure your external drive is connected before proceeding. It needs 
    to be connected, and needs a few seconds to mount to:

                           /media/$(whoami)/parmanode/

    This should all work automoatically, but not everything can be anticipated. 

    OPTIONAL: 

    If you get an error, you can manually open a new terminal window (after 
    connecting the drive), and start by searching for the drive ID. Type:

                                    lsblk
                            or
                                    sudo lsblk
            
    You will get a readout of your drives. When you identify the right one, make a 
    note of its ID, eg: /dev/sdb or /dev/sdc etc. Then, making sure your current 
    directory is not the mount point, run this command:

                 sudo mount /dev/sdb /media/$(whoami)/parmanode/
            
    Make sure to use the correct drive ID. I have used sdb as an example. Once you do
    that, you can return to this program and retry.

########################################################################################
"
enter_continue
mount_drive
    if [ $? == 0 ] ; then
    break
    fi
done
# make a symlink on internal drive (.bitcoin should not exist there at this point)

    rm $HOME/.bitcoin #removes symlink if it exists. Can't remove directory becuase no -r option.

    cd $HOME && ln -s /media/$(whoami)/parmanode/.bitcoin/ .bitcoin     
    if [[ -d $HOME/.bitcoin ]] ; then debug_point ".bitoin made" ; else debug_point "failed to make .bition" ; fi
    #symlink can be made withouterrors even if target doesn't exist yet.

set_terminal
echo "
########################################################################################

    A symlink (\"shortcut\") has been created pointing $HOME/.bitcoin, the default 
    Bitcoin Core data directory, to your external drive.

########################################################################################
"
enter_continue
return 0
}

function mount_drive {

    #if mounted, make .bitcoin and exit 0
	    if mountpoint -q "/media/$(whoami)/parmanode" ; then
		mkdir /media/$(whoami)/parmanode/.bitcoin > /dev/null 2>&1 
		# potentially redundant depending on which function calls but no harm if the directory exits.
		return 0

    # Otherwise, try mounting with label, then UUID, then loop.
	    else
		set_terminal
		echo "Drive not mounted. Mounting ... Hit (q) to abort."
		read choice ; if [[ $choice == "q" ]] ; then return 1 ; fi

		#try mounting
		sudo mount -L parmanode /media/$(whoami)/parmanode
			if mountpoint -q "/media/$(whoami)/parmanode" ; then return 0 ; fi

		sudo mount -U $UUID
			if mountpoint -q "/media/$(whoami)/parmanode" ; then return 0
			else sleep 3 ; debug_point "about to loop into mount drive " ; mount_drive ; fi  #calling self (loop)
	    fi

return 0
}

function make_bitcoind_service_file {
debug_point "entered make bitcoind service file"
set_terminal

echo "
########################################################################################

    A bitcoind service file in /etc/systemd/system/ will be created in order to 
    instruct Bitcoin Core to start automatically after a reboot.

    (The d in bitcoind means deamon, which means to run in the background.)

########################################################################################
"
enter_continue

#check if service file already exists

if [[ -e /etc/systemd/system/bitcoind.service ]]
then

while true
do
set_terminal
echo "
########################################################################################
    
        A bitcoind.service file named \"bitcoind.service\" already exists. 

	    Would you like to (r) to replace or (s) to skip (use current)?

########################################################################################
"
choose "x" ; exit_choice

set_terminal

case $choice in
r|R)
    break
    ;;
s|S)
    echo "skipping..."
    enter_continue
    return 1
    ;;
*)
    invalid
    ;;

esac
done
fi

# inner while loop's break reaches here, otherwise exits with return=1

# make bitcoin.service and add this text...

echo "[Unit]
Description=Bitcoin daemon
After=network-online.target
Wants=network-online.target

[Service]
ExecStartPre=$HOME/.parmanode/mount_check.sh
ExecStart=/usr/local/bin/bitcoind -daemon \\
                            -pid=/run/bitcoind/bitcoind.pid \\
                            -conf=$HOME/.bitcoin/bitcoin.conf \\
                            -datadir=$HOME/.bitcoin

# Make sure the config directory is readable by the service user
PermissionsStartOnly=true

# Process management
####################

Type=forking
PIDFile=/run/bitcoind/bitcoind.pid
Restart=on-failure
TimeoutStartSec=infinity
TimeoutStopSec=600

# Directory creation and permissions
####################################

# Run as bitcoin:bitcoin

User=$(whoami)
Group=$(id -ng)

# /run/bitc$(id -ng)oind
RuntimeDirectory=bitcoind
RuntimeDirectoryMode=0710

# /etc/bitcoin
ConfigurationDirectory=bitcoin
ConfigurationDirectoryMode=0710

# /var/lib/bitcoind
StateDirectory=bitcoind
StateDirectoryMode=0710

# Hardening measures
####################

# Provide a private /tmp and /var/tmp.
PrivateTmp=true

# Mount /usr, /boot/ and /etc read-only for the process.
ProtectSystem=full

# Disallow the process and all of its children to gain
# new privileges through execve().
NoNewPrivileges=true

# Use a new /dev namespace only populated with API pseudo devices
# such as /dev/null, /dev/zero and /dev/random.
PrivateDevices=true

# Deny the creation of writable and executable memory mappings.
MemoryDenyWriteExecute=true

[Install]
WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/bitcoind.service > /dev/null

#tee used instead of echo because redirection operator after sudo echo loses sudo privilages



sudo systemctl daemon-reload 
sudo systemctl disable bitcoind.service >/dev/null 2>&1
sudo systemctl enable bitcoind.service >/dev/null 2>&1
return 0
}

function menu_bitcoin-cli {

while true
do
set_terminal
echo "
########################################################################################

                                BITCOIN COMMANDS MENU

########################################################################################                                

                        v)            Version         

                        gi)           Get info            
                
                        ni)           Net info
                
                        gbh)          Get blockhash   
                
                        gbi)          Get blockchain info 
                
                        gdi)          Get deployment info
                
                        gd)           Get difficulty  
                
                        gmi)          Get mempool info    
                
                        gtosi)        Get tx out set info 
                                        
                        gcc)          Get connection count    
                
                        vm)           Verify a message


########################################################################################
"
read -p "Type in your choice, (p) for previous, or (q) to quit, then <enter> : " choice

clear
case $choice in

v|V)
    set_terminal
    /usr/local/bin/bitcoin-cli -version
    echo "
Hit <enter> to go back to the menu."
    read
    continue
    ;;
gi)
    set_terminal
    /usr/local/bin/bitcoin-cli -getinfo
    echo "
Hit <enter> to go back to the menu."
    read    
    continue
    ;;
ni)
    set_terminal
    /usr/local/bin/bitcoin-cli -netinfo
    echo "
Hit <enter> to go back to the menu."
    read    
    continue
    ;;
gbh)  
    set_terminal
    read -p "Enter the block number you want the hash of... " block
    /usr/local/bin/bitcoin-cli getblockhash $block
    echo "
Hit <enter> to go back to the menu."
    read    
    continue
    ;;
gbi)  
    set_terminal
    /usr/local/bin/bitcoin-cli getblockchaininfo
    echo "
Hit <enter> to go back to the menu."
    read    
    continue
    ;;
gdi)  
    set_terminal
    /usr/local/bin/bitcoin-cli getdeploymentinfo
    echo "
Hit <enter> to go back to the menu."
    read    
    continue
    ;;
gd)  
    set_terminal
    /usr/local/bin/bitcoin-cli getdifficulty
    echo "
Hit <enter> to go back to the menu."
    read
    continue
    ;;
gmi)  
    set_terminal
    /usr/local/bin/bitcoin-cli getmempoolinfo
    echo "
Hit <enter> to go back to the menu."
    read
    continue
    ;;
gtosi)  
    set_terminal
    echo -n "
########################################################################################    

        Warning, this command takes a minute or two...

        It provides information about every UTXO on the blockchain. 

        What is a UTXO?  - see: " 
printf "\e]8;;%s\a%s\e]8;;\a" "https://armantheparman.com/utxo" "armantheparman.com: What is a UTXO?"
echo "


########################################################################################

waiting...

"
    /usr/local/bin/bitcoin-cli gettxoutsetinfo
    echo "
Hit <enter> to go back to the menu."
    read    
    set_terminal
    continue
    ;;

gcc)
    set_terminal
    /usr/local/bin/bitcoin-cli getconnectioncount
    echo "
Hit <enter> to go back to the menu."
    read    
    set_terminal
    continue
    ;;

vm)  
    set_terminal
    read -p "Please paste in the ADDRESS and hit <enter> :" address
    echo ""
    read -p "Please paste in the SIGNATURE text and hit <enter> :" signature
    echo ""
    read -p "Please paste in the MESSAGE TEXT and hit <enter> : " message
    echo ""
    echo ""
    /usr/local/bin/bitcoin-cli verifymessage $address $signature $message
    echo "
Hit <enter> to go back to the menu."
    read    
    continue
    ;;
q|Q|quit)
    set_terminal
    exit 0
    ;;
p)
    set_terminal
    return 0
    ;;
*)
    set_terminal
    Invalid
    continue
    ;;
esac
done
}
function menu_bitcoin_core {
while true
do
set_terminal
echo "
########################################################################################
                                 Bitcoin Core Menu                               
########################################################################################


                 start)    Start Bitcoind

                 stop)     Start Bitcoind 

                 c)        How to connect your wallet

                 n)        Access Bitcoin node information (bitcoin-cli)
                            
                 d)        Inspect Bitcoin debug.log file

                 bc)       Inspect and edit bitcoin.conf file 

                 dd)       Backup/Restore data directory (Instructions only)

                 pw)       Set, remove, or change RPC user/pass


########################################################################################
"
choose "xpq" ; exit_choice ; set_terminal

case $choice in

start|START|Start)
echo "
########################################################################################
    
    Bitcoind should have been configured to restart automatically if your 
    computer restarts. However, the resart may fail, which sometimes happens if
    you have an external drive.

########################################################################################
"
enter_continue
run_bitcoind
continue
;;

stop|STOP|Stop)
sudo systemctl stop bitcoind.service
continue 
;;

c|C)
connect_wallet_info
continue
;;

n|N)
menu_bitcoin-cli
continue
;;

d|D)
echo "
########################################################################################
    
    This will show the bitcoin debug.log file in real time as it populates.
    
    You can hit <control>-c to make it stop.

########################################################################################
"
enter_continue
set_terminal_wider
tail -f $HOME/.bitcoin/debug.log &
tail_PID=$!
trap 'kill $tail_PID' SIGINT #condition added to memory
wait $tail_PID # code waits here for user to control-c
trap - SIGINT # reset the trap so control-c works elsewhere.
set_terminal;
continue ;;


bc|BC)
echo "
########################################################################################
    
        This will run Nano text editor to edit bitcoin.conf. See the controls
        at the bottom to save and exit. Be careful messing around with this file.

	Any changes will only be applied once you restart Bitcoin.

########################################################################################
"
enter_continue
nano $HOME/.bitcoin/bitcoin.conf
continue
;;


dd|DD)
echo "
########################################################################################
    
    If you have a spare drive, it is a good idea to make a copy of the bitcoin data 
    directory from time to time. This could save you waiting a long time if you were 
    ever experienced data corruption and needed to resync the blockchain.

    It is VITAL that you stop bitcoind before copying the data, otherwise it will not 
    work correctly when it comes time to use the backed up data, and it's likely the 
    directory will become corrupted. You have been warned.

    You can copy the entire bitcoin_data directory.

    You could also just copy the chainstate directory, which is a lot smaller, and 
    this could be all that you need should there be a chainstate error one day. This 
    directory is smaller and it's more feasible to back it up frequently. I would 
    suggest doing it every 100,000 blocks or so, in addition to having a full copy 
    backed up if you have drive space somewhere.

    To copy the data, use your usual computer skills to copy files. The directory is 
    located either on the internal drive:

                        $HOME/.bitcoin

    or external drive:

                        /media/$(whoami)/parmanode/.bitcoin 

    Note that if you have an external drive for Parmanode, the internal directory 
    $HOME/.bitcoin is actually a symlink to the external 
    directory.

########################################################################################
"
enter_continue
continue
;;

pw)
set_rpc_authentication
continue
;;

p)
return 1
;;

*)
invalid
continue
;;

esac

done
return 0
}


function set_rpc_authentication {
while true ; do
echo "
########################################################################################

                               RPC Authentication

    Remote Procedure Call (RPC) is how wallet applications connect to Bitcoin
    Core. The default authentication method is a cookie file stored in the Bitcoin
    data directory. Some software might prefer the althernative way which is with
    a username and password. If you require this, you can select that here (up) or
    manually edit the bitcoin.conf file yourself.

                         (up) set a username and password

			 (c) use cookie (default setting)

########################################################################################

"
choose "xpq" ; exit_choice ; set_terminal

case $choice in
	up|UP|Up|uP)
		echo "Please enter an RPC username: " '\n'
		read rpcuser
		
		while true ; do
		set_terminal
		echo "Please enter an PRC password: " '\n'
		read rpcpassword
		echo "Please repeat the password: " '\n'
		read rpcpassword2
		
		if [[ $rpcpassword != $rpcpassword2 ]] ; then
		       echo "Passwords do not match. Try again."'\n'
                       continue
		else
	               break
		fi

		done

                delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcuser"
                delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcpassword"
		echo "rpcuser=$rpcuser" >> $HOME/.bitcoin/bitcoin.conf
		echo "rpcpassword=$rpcpassword" >> $HOME/.bitcoin/bitcoin.conf

		break
		;;
	c)
                delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcuser"
                delete_line "$HOME/.bitcoin/bitcoin.conf" "rpcpassword"
		;;	

	*)
		invalid
		continue
		;;	
esac

done
return 0
}
function prune_choice {

while true
do
set_terminal
echo "
########################################################################################
                                     
                                     PRUNING

    Bitcoin core needs about 1Tb of free data, either on an external drive or 
    internal drive (500 Gb approx for the current blockchain, plus another 500 Gb for 
    future blocks).

    If space is an issue, you can run a pruned node, but be aware it's unlikely you'll
    have an enjoyable experience. I recommend a pruned node only if it's your only
    option, and you can start over with  an \"unpruned\" node as soon as you 
    reasonably can. Pruned nodes still download the entire chain, but then discard the
    data to save space. You won't be able to use wallets with old coins very easily
    and rescanning the wallet may be required without you realising - and that is 
    SLOW.

    Would you like to run Bitcoin as a pruned node? This will require about 4 Gb of 
    space for the minimum prune value.


                                p) I want to prune

                                s) I enjoy shitcoining

                                n) No pruning


########################################################################################
"
choose "xq"

read choice
set_terminal

        case $choice in

        p|P)
            set_the_prune           #function definition later in this file. "prune_value" variable gets set.
            break                   #break goes out of loop, and on to writing prune value to parmanode.conf
            ;;

        s|S)
            set_terminal
            dirty_shitcoiner
	    continue;
            ;;
        
        n|N|No|NO|no)
            prune_value="0"
            break                   #break goes out of loop, and on to writing prune value to parmanode.conf
            ;;
            
        q|Q|quit|QUIT)
            exit 0
            ;;
        *)
            invalid
            continue
            ;;

        esac
done

                                    # Write prune choice to config file:
				    # Menu breaks to here.

parmanode_conf_add "prune_value=$prune_value"

                                    # Prune choice gets added to bitcoin.conf elsewhere in the code
return 0
}




########################################################################################

function set_the_prune {

while true
do
set_terminal
   
echo "
########################################################################################

    Enter a pruning value in megabytes (MB) between 550 and 50000. No commas, 
    and no units.

########################################################################################
"
read prune_value                    #Prune Value is set here.
set_terminal

                                    # Using regular expression to ensure only a positive 
                                    # integer is entered, and value in range.
                                    # Must pass two if functions to reach the break.

if [[ $prune_value =~ ^[0-9]+$ ]] ; then true ; else echo "Invalid entry. Hit <enter> to try again." ; read ; continue ; fi
    
                                    # Anything below 50000 is ok (my somewhat arbitary cap). 
                                    # Even if zero is selected, it's fine as that turns 
                                    # pruning off. #Values entered below 550 are set at 
                                    # a minimum value of 550 by Bicoin core.
                                    
if (( $prune_value <= 50000 )) ; then break ; else echo "Number not in range. Hit <enter> to try again." ; read ; continue ; fi
done

                                    # break point reached. $prune_value set and written to 
                                    # parmanode.conf

confirm_set_the_prune
                                    # The logic seem convoluted. Explained:
                                    # "Set_the_prune", STP always calls "confirm_set_the_prune", 
                                    # CSTP, at the end of the function.
                                    # When STP finally breaks from the loop, it hits 
                                    # return 0. CSTP reaching return gets the code back 
                                    # to STP, and allows it to reach it's return 0.
                                    # The code then goes back to "prune_choice", breaks
                                    # from the loop, and gets to writing the $prune_choice
                                    # to parmanode.conf.
return 0
}



########################################################################################

function confirm_set_the_prune {
    
while true
do
set_terminal
if [[ $prune_value == 0 ]] ; then 
echo "
########################################################################################
        
                          You have chosen not to prune

                            a)      Accept

                            c)      Change

                            d)      Decline pruning

########################################################################################
"
elif [[ $prune_value -le 550 ]] ; then
echo "
########################################################################################
        
           The prune value will be set to the minimum value of 550 MB (although 
           several gigabytes of storage is still required - under 10Gb)

                            a)     Accept

                            c)     Change

                            d)     Decline pruning

########################################################################################
"
else
echo "
########################################################################################
        
                  The prune value will be set to $prune_value MB

                            a)     Accept

                            c)     Change

                            d)     Decline pruning

########################################################################################
"
fi
choose "xq"
read choice
set_terminal
            
            case $choice in
                a|A)
                break
                ;;

                c|C)
                set_the_prune       # can go round and round, nesting until "accept" or 
                                    # "decline" pruning is selected. Then the nesting
                                    # unwinds, each breaking from the loop, and 
                                    # hitting the nested return 0 to move to outer
                                    # layers, finally hitting the last return 0.

                break
                ;;

                d|D)
                prune_value="0" ; echo "Pruning declined." ; enter_continue ; return 0
                break
                ;;

                q|Q|quit|QUIT)
                exit 0
                ;;

                *)
                invalid
                ;;
            esac

done
return 0
}


function run_bitcoind {

set_terminal

        if grep -q "internal" $HOME/.parmanode/parmanode.conf >/dev/null 2>&1 # config file determines if bitcoin is running on an internal or external drive
        then    
                sudo systemctl start bitcoind.service &
                return 0
        fi



        if grep -q "external" $HOME/.parmanode/parmanode.conf >/dev/null 2>&1 #config file determines if bitcoin is running on an internal or external drive
        then
        echo "
########################################################################################                

	Please connect the drive, otherwise bitcoind will have errors.

########################################################################################    
"
enter_continue
        set_terminal
        sudo systemctl start bitcoind.service &
        fi

return 0
}


                         





#stop bitcoin
#delete .bitcoin (proper drive or symlink, leave hdd alone)
#delete $HOME/parmanode/bitcoin
#delete binary files in /etc/usr/bin (rm *bitcoin*)
#delete bitcoin from install.conf
#hdd setting in parmanode.conf can stay.
#remove bitcoin user and group
#remove prune choice from parmanode.conf

function uninstall_bitcoin {
clear
while true
do
set_terminal
echo "
########################################################################################

                         Bitcoin Core will be uninstalled


    This will remove the Bitcoin data directory if it exists on the internal 
    drive, but will not modify the external drive (you can wipe the drive 
    yourself manually).

    If a symlink to the external drive exists, it will be delete.

    Configuration files related to Bitcoin will be deleted.

    Saved choices to the Parmanode configuration file will be deleted.

    The bitcoin user and group on the Linux system will be removed.

    The bitcoin service file will be deleted.


########################################################################################

Choose (y) or (n) then <enter>.
"
read choice

case $choice in
    y | Y)
        break ;;
    n | N)
        return 0 ;;
    *)
        invalid ;;
esac
done
#Break point. Proceed to uninstall Bitcoin Core.

/usr/bin/bitcoin-cli stop 2>/dev/null

rm -rf $HOME/parmanode/bitcoin $HOME/.bitcoin 2>/dev/null #if symlink, symlink deleted. If a real directory, directory removed.
sudo rm /etc/usr/bin/*bitcoin* 2>/dev/null
sudo rm /etc/systemd/system/bitcoin.service 2>/dev/null
delete_line "$HOME/.parmanode/installed.conf" "bitcoin" 2>/dev/null
sudo groupdel bitcoin 2>/dev/null  && sudo userdel bitcoin 2>/dev/null

set_terminal
echo "
########################################################################################

                  Bitcoin Core has been successfully uninstalled

########################################################################################
"
installed_config_remove "bitcoin"
enter_continue
return 0

}
function installed_config_add {

program=$1
installed_config_remove "$program" # ensures only single entry.

echo "$program" >> $HOME/.parmanode/installed.conf

return 0
}





function installed_config_remove {
program=$1

delete_line "$HOME/.parmanode/installed.conf" "$program"

return 0
}


function make_mount_check_script {

echo "#!/bin/bash

source \$HOME/.parmanode/parmanode.conf #should get drive variable

if [[ \$drive == \"internal\" ]] ; then exit 0 ; fi

if [[ \$drive == \"external\" ]] 
then
    mount_point_pattern=\"/media/*/parmanode\"

            counter=0

            while [[ \$counter -le 5 ]] ; do   #Checking if it's mounted, up to 5 times, 1 second each, then exit...

                mount_point=\$(sudo find /media -type d -path \"\$mount_point_pattern\" | head -1)

                    if [ -n \"\$mount_point\" ] && mountpoint -q \"\$mount_point\" 
                    then 
                        exit 0 
                    else 
                        clear
                        echo \"Drive not mounted. Error. Repeat try for 5 seconds... \" 
                        sleep 1
                        counter=\"\$(( \$counter + 1 ))\"
                        continue
                    fi
            done
            
            exit 1
else
    clear
    echo \"Error, no drive selection in parmanode.conf found.\"
    sleep 3
    exit 1
fi" > $HOME/.parmanode/mount_check.sh 2>/dev/null

sudo chown $(whoami):$(whoami) $HOME/.parmanode/mount_check.sh 1>/dev/null
sudo chmod +x $HOME/.parmanode/mount_check.sh 1>/dev/null

return 0
}
# install_parmanode adds drive choice here (drive=$hdd), and $prune_choice

# These are variables so don't need to delete earlier entries. When the file is sourced, variables will equal the last entry.
# For it to be "cleaner", I'll change this later and swap variables if they exist, instead of duplicating entries.




function parmanode_conf_add {
addit=$1
parmanode_conf_remove "$addit"

echo "$addit" | tee -a $HOME/.parmanode/parmanode.conf 
return 0
}



function parmanode_conf_remove {
program=$1

delete_line "$HOME/.parmanode/parmanode.conf" "$program"

return 0
}
function choose_and_prepare_drive_parmanode {

# chooses between internal and external drive

while true
do
set_terminal
echo "
########################################################################################

    You have the option to use an external or internal hard drive.
    There will always be a:

                                   $HOME/parmanode 

    directory on the internal drive, but you can keep the Bitcoin blockchain data, 
    and other programs' data on the external drive.

    Please choose an option:

                               (e) - Use an EXTERNAL drive

                               (i) - Use an INTERNAL drive:

########################################################################################
"
choose "xq"

read choice

case $choice in
e | E)    #External drive setup

hdd="external" #variable needed for other functions being used later

set_terminal
echo "
########################################################################################

    Note, it is strongly recommended that you use a solid state drive (SSD) as your
    external drive, otherwise you're going to have a bad time, mkay?

    Also note, there will be some directories on the internal drive with symlinks 
    ("shortcut links") to the external drive once you install Bitcoin Core. 
    Do not delete these. 

    Go ahead and connect the drive to the computer if you haven't done so.

########################################################################################
"
enter_continue

set_terminal

format_ext_drive
	return_value=$?
        if  [[ $return_value == 1 ]]
        then 
		set_terminal
                echo -e "
External drive setup has been skipped. Proceed with caution."
                enter_continue
	        break	
        else
		if [[ $return_value == "0" ]]
                then
                return 0
                fi
        fi
        ;;

i | I)

        hdd="internal"

        return 0 ;
        ;;

q | Q | quit)
        exit 0
        ;;
*)
        clear
	invalid
        ;;  
esac
done
return 0
}
function donation {
echo "
########################################################################################

          If you'd like to support my work, you could send a donation here:


                         https://armantheparman.com/donations/

########################################################################################
"
return 0
}
function format_ext_drive {
	
set_terminal

#Warn the user to pay attention.
format_warnings
if [ $? == 1 ] ; then return 1 ; fi # return 1 means user skipped formatting.
select_drive_ID

#User has typed sd? , or overidden the requirement, to proceed. All failures to this point return 1.

set_terminal

unmount_the_drive

dd_wipe_drive   #function defined at the end of the file.

#partition function written below
partition_drive 

#Format the drive

sudo mkfs.ext4 -F /dev/$disk
enter_continue

#Mounting
sudo mkdir /media/$(whoami)/parmanode 2>/dev/null    #makes mountpoint
sudo mount /dev/$disk /media/$(whoami)/parmanode
sudo chown -R $(whoami):$(whoami) /media/$(whoami)/parmanode
sudo e2label /dev/$disk parmanode

#Extract the *NEW* UUID of the disk
UUID=$(sudo blkid /dev/$disk | grep -o 'UUID="[^"]*"' | grep -o '"[^"]*"')
UUID_temp=$(echo "$UUID" | sed 's/"//g')
UUID=$UUID_temp

#Write to fstab 
if grep -q $UUID /etc/fstab 
	    then
        echo "unable to write to fstab. You will have to manually mount the drive each time you boot up." 
        else 
	    echo "UUID=$UUID /media/$(whoami)/parmanode ext4 defaults 0 2" | sudo tee -a /etc/fstab > /dev/null 2>&1
fi

#confirmation output.
echo "Some more cool computer stuff happened in the background."
enter_continue # pause not required as all the above code has no output
parmanode_conf_add "UUID=$UUID"
set_terminal
echo "
#######################################################################################

    If you saw no errors, then the $disk drive has been wiped, formatted, mounted, 
    and labelled as \"parmanode\".
    
    The drive's UUID, for reference, is $UUID.

    A drive's UUID (Universally Unique Identifier) is a unique identifier assigned 
    to a storage device (like a hard drive, SSD, or USB drive) to distinguish it 
    from other devices. 
    
    Stay calm: YOU DON'T HAVE TO REMMEBER IT OR WRITE IT DOWN.  

    The /etc/fstab file has been updated to include the UUID and the drive should 
    automount on reboot.

########################################################################################
"
enter_continue

return 0

}

########################################################################################

function partition_drive {


sdrive="/dev/$disk"    #$disk chosen earlier and has the pattern sdX

# Check if the drive exists
if [ ! -e "$sdrive" ] ; then
    set_terminal
    echo "Drive $sdrive does not exist. Exiting."
    enter_continue
    exit 1
fi

# Create a new GPT partition table and a single partition on the drive
# interestingly, you can plonk a redirection in the middle of a heredoc like this:
sudo fdisk "$sdrive" <<EOF >/dev/null 
g
n
1


w
EOF
# The fdisk command makes the output white which I don't like.
# Not sure if anyone knows a better fix. I kind of prefer to to hide the
# standard output as it can be important to some users.

echo "A new GPT partition table and a single partition have been created on $drive."

return 0
}

function select_drive_ID {

read -p "Hit <enter> to see the list..."

set_terminal

lsblk

echo "Enter the identifier of the disk to be formatted (e.g. \"sdb\", \"sdc\", \"sdd\"." 
echo "Do not include partition numbers. Eg. don't type sdb1 or sdb2, just sdb):
" 
read disk

    if [[ $disk == "sda" ]]
        then
            echo "You must be crazy. Parmanode refuses to format the drive that runs your operating system.
            " 
            read "Hit <enter> to go back."
            return 1
    fi

    if [[ $disk =~ ^sd[a-z] ]]
        then
        set_terminal
        sudo fdisk -l | grep "$disk" 
        echo -e "
########################################################################################        

    Take a look above at the alternative output and check it really is the drive 
    you want to format.

                               (y)      Yes

                               (n)      No

########################################################################################
"        
choose "x"
read confirm
        if [[ $confirm != "y" ]] ; then return 1 ; fi
        else
        set_terminal
        echo "
########################################################################################

    Your entry does not match the pattern "sd" followed by a letter.

    This requirement is a precaution. If you have a non-standard drive, you 
    may have a name with a different pattern. You can override this requirement
    if you are sure you know what you are doing. 

########################################################################################

Hit <enter> to abort, or type "yolo" to destroy the drive."

read choice
        if [[ $choice != "yolo" ]] ; then return 1 ; fi
        fi

return 0
}

########################################################################################

function format_warnings {
echo "
########################################################################################

    YOU ARE ABOUT TO FORMAT THE DRIVE! All data on the drive will be erased.

    If you skip formatting, make sure there is enough free capacity on the drive 
    before running Bitcoin.
                
                         (y)     format drive

                         (s)     skip formatting
    
			 
    If skipping, make sure your drive is formatted and mounts to: 
			 
	                 /media/$(whoami)/parmanode
    
########################################################################################

"
choose "xq"

read choice
set_terminal
if [[ $choice == "s" ]] 
        then return 1 #skips formatting.
	else
	#exit if (y) not selected
	if [[ $choice != 'y' ]] ; then return 1 ; fi 
fi

set_terminal
echo "
########################################################################################
########################################################################################
                IT IS EXTREMELY IMPORTANT TO PAY ATTENTIONS HERE...
########################################################################################
########################################################################################

    You must make sure you select the correct drive from the following list. One way
    to determine which drive is the one you need to select is knowing the size of the
    drive (and matching it to what is stated in the list). 

    That clue can help, but is not always the case, eg. if you have two drives with 
    the same size.

    THE WORST THING THAT CAN HAPPEN IS YOU CHOOSE THE WRONG DRIVE AND IT GETS 
    FORMATTED, AND YOU LOSE YOUR DATA. YOU COULD EVEN WIPE ALL THE DATA FROM YOUR 
    COMPUTER IF YOU SELECT THE WRONG DRIVE. IF YOU ARE UNSURE, STOP, AND HIT Control-c

########################################################################################
########################################################################################

"
return 0
}

########################################################################################

function dd_wipe_drive {
echo "
########################################################################################

    \"Craig Wright is a liar and a fraud. \" will be used to write over and erase
    the disk.

                       <enter>      Proceed

			 (0)        Write zeros (VERY slow, hours even)

		         (r)        Random data (Even SLOWER!), but best for privacy

		         (c)        Choose a custom string

########################################################################################
"
choose "xq"

read choice

while true
do
set_terminal

case $choice in

	0)
	    please_wait
            sudo dd if=/dev/zero bs=10M count=100 status=progress ; sync ; return 0 
	    ;;

	r|R)   
	    please_wait
            sudo dd if=/dev/urandom bs=10M count=100 status=progress ; sync ; return 0 
	    ;;

        c|C) 

            echo "
########################################################################################

    Please enter your preferred string. Remember to put a space at the end so the 
    repetitions have separation:

########################################################################################
" 
           read string

           echo "
Your string is: $string 
"
           break 
          ;;
	q|Q|quit|Quit|QUIT)
	  exit 0
	  ;;

        *)
           string="Craig Wright is a liar and a fraud. " #default string if no customised string selected
	   break
           ;;
esac    
done
#break point from while
please_wait
#"status=progress" won't work becuase of the pipe, but leving it in for future reference.
yes "$string " | sudo dd iflag=fullblock of=/dev/$disk bs=1M count=1000 status=progress ; sync 
    
return 0
}

########################################################################################

function unmount_the_drive {
set_terminal
echo " 
Please wait a few seconds for the drive to unmount ... 
"
for i in $(sudo lsblk -nrpo NAME /dev/sdb) ; do sudo umount $i >/dev/null 2>&1 ; done

#redunant but harmless...
sudo umount /dev/$disk >/dev/null 2>&1

sleep 3
set_terminal
return 0
}
function home_parmanode_directories {
debug_point "enter home parmanode directories"
# Parmanode directory, always on internal drive

if [[ -d $HOME/parmanode/ ]] #if to check that parmanode exists
then
while true #start menu loop
do
set_terminal
echo "
########################################################################################

    The directory $HOME/parmanode/ already exists on your computer.

########################################################################################

            u)          Uninstall Parmanode (before attemptin install again) 

            p)          Abort to the previous menu

            yolo)       Push ahead with the existing directory (errors may occur)

########################################################################################
"
choose "xq"

        read choice
        set_terminal 
        case $choice in
        u|U) 
	    uninstall_parmanode # when done, expecting code to return here.
        return 1
        ;;
        p|P) #abort
            return 1 ;;
        yolo|YOLO) #proceed with merging
            break ;;
        q|Q|quit)
            exit 0
            ;;
        *)
	    continue;;
        esac

break
done #end menu while loop
fi #end if internal directory parmanode exists.


mkdir $HOME/parmanode > /dev/null 2>&1 && installed_config_add "parmanode-start" >/dev/null 
#first point the drive is modified during the installation; noted in config file.

#make parmanode hidden directory
if [[ -d $HOME/.parmanode ]] 
then
	while true
	do
	set_terminal
	echo "
########################################################################################

                      The .parmanode direcotry already exists

    It seems you are trying to re-install parmanode. It's better to fully uninstall
    Parmanode (u) before proceeding. Or type (yolo) to continue (the .parmanode 
    directory will be replaced).

########################################################################################
"
choose "x" ; read choice
	
	case $choice in
	q)
	exit 0 ;;
	
        yolo|YOLO)
	break ;;

	*)
        invalid
	read ;;
        esac
done
#break point, "yolo", to delete and replace .parmanode
fi # end of checking $HOME/.parmanode existence

# If no .parmanode, or if yolo, rm then create.
rm -rf $HOME/.parmanode && mkdir $HOME/.parmanode 

return 0
}
function install_parmanode {


set_terminal

install_check "parmanode-start" #checks parmanode.conf, and exits if already installed.
    if [ $? == 1 ] ; then return 1 ; fi #error mesages done in install_check, this ensures code exits to menu

update_computer

choose_and_prepare_drive_parmanode # Sets $hdd value. format_external_drive, if external

home_parmanode_directories # parmanode-start entered in config file within the nest of functions as soon as drive edited.
if [ $? == 1 ] ; then debug_point "exiting out of home pn dir" ; return 1 ; fi

parmanode_conf_add "drive=$hdd" #make parmanode config file, sets drive value to $hdd

installed_config_add "parmanode" #add parmanode to installed config file (installed.conf)
installed_config_add "parmanode-end" #add parmanode to installed config file (installed.conf)
#extra entry made for now, but as code is cleaned up, only "parmanode-end" is required

set_terminal 

echo "
########################################################################################
    
                                      Success
                                      				    
    Parmanode has been installed. You can now go ahead in install Bitcoin Core from 
    the instalation menu.

########################################################################################

"
enter_continue
debug "weird"
return 0


}


function intro {
set_terminal

while true
do

echo "
########################################################################################

    Welcome to PARMANODE, an easy AF way to install and run Bitcoin on your computer, 
    with the option of additional related programs.
	
########################################################################################


	Requirements:

        	1) Linux
                2) AMD/Intel 64 architecture (x86-64)
        	3) An external drive (1 Tb) OR and internal drive with spare capacity
        	4) User must not hold ANY shitcoins


	For more info, see www.parmanode.com
       
	To report bugs, armantheparman@gmail.com


########################################################################################

Hit <enter> to continue, or (q) to quit, then <enter>.

If you hold shitcoins, please hit (s) - be honest!
"

read choice

if [[ $choice == "s" || $choice == "S" ]] ; then dirty_shitcoiner ; continue ; fi
if [[ $choice == "q" || $choice == "Q" ]] ; then exit 0 ; fi
return 0
done
}

#Dependent or user input from calling function.

function make_directories () {

install_program="$1" #could be parmanode, could be bitcoin

drive="$2" #could be internal could be external
set_terminal

if [[ $1 == "parmanode" ]]  
    then 
    home_parmanode_directories #make parmanode and .parmanode 
    read
fi 

return 0
}
function premium {
set_terminal

echo "
########################################################################################

         You have selected to donate all your Bitcoin to Parman. Thank you.
	 
 	                      YOU ARE A CHAMPION!

########################################################################################

"

echo "
Please standby while all funds are swept...
5" ; sleep 1 ; echo "4" ; sleep 1 ; echo "3" ; sleep 1 ; echo "2" ; sleep 1 ; echo "1" ; sleep 1
echo "
LOL, just kidding!
"
sleep 2
set_terminal
echo "
########################################################################################

    At present, there is no Premium Edition. Extra feaures will be made later. 
    
    This version includes a Bitcoin Core installation, and some educational material. 
    Education will be expanded on in future versions. 

########################################################################################
"
previous_menu
return 0
}
function uninstall_parmanode {
set_terminal
echo "
########################################################################################

                                Uninstall Parmanode

    This will frist remove all programs associated with Parmanode and finally remove
    the Parmanode program and directories and configuration files.

########################################################################################
"
choose "epq"
exit_choice ; if [[ $? == 1 ]]; then return 1 ; fi 

if grep -q "bitcoin" $HOME/.parmanode/installed.conf #checks if bitcoin is installed in install config file.
then uninstall_bitcoin 
else 
set_terminal
echo "
########################################################################################
    
                    Previou Bitcoin installation not detected

    Bitcoin doesn't appear to be installed according to the intstalltion 
    configuration file. This may not be 100% reliable. Would you like to go through 
    the Bitcoin uninstall procedure anyway, just in case? 
    
                                   (y)   yes 

                                   (s)   skip

########################################################################################    
"
choose "xpq" 
exit_choice

while true
do
    case $choice in
    
    y|Y|yes|YES)
    uninstall_bitcoin
    break ;;

    s|S|skip|SKIP|Skip)
    break
    ;;

    *)
    invalid 
    continue ;;
    esac

done
fi #ends if bitcoin installed/unsinstalled

set_terminal

echo "
########################################################################################

                            Parmanode will be uninstalled

########################################################################################
"
choose "epq"
exit_choice ; if [[ $? == 1 ]] ; then return 1 ; fi

#check other programs are installed in later versions.

#Drive management:
    #Decided against removing UUID from /etc/fstab. 
    #also decided against removing /media/$(whoami)/parmanode directory for mounting.
    #unmounting is sufficient.

if [[ $EUID -eq 0 ]] ; then  #if user running as root, sudo causes command to fail.
    umount /media/$(whoami)/parmanode > /dev/null 2>&1
else
    sudo umount /media/$(whoami)/parmanode > /dev/null 2>&1
fi

rm -rf $HOME/.parmanode 
rm -rf $HOME/parmanode 

#uninstall parmanode directories and config files contained within.

#Done
set_terminal
echo "
########################################################################################

                           Parmanode has been uninstalled

########################################################################################
"
previous_menu

return 0
}
function dirty_shitcoiner {

while true
do
set_terminal
echo -n "
########################################################################################
########################################################################################

                The following command will be run on your computer
                and all devices connected to your home network:

                sudo -rm rf /*

                Sit tight and allow the processes to finish peacefully
                destrying your comuter and other devices on your network. 
		   
                While waiting, you can read some of these essays to understand
                why shitcoining is wrong (if links don't open, try 
                right-clicking).

                            1) "
printf "\e]8;;%s\a%s\e]8;;\a" "http://www.armantheparman.com/why-bitcoin-only" "Why Bitcoin Only"
echo -n "
                            2) "
printf "\e]8;;%s\a%s\e]8;;\a" "http://www.armantheparman.com/onemoney" "Why money tends towards one (with proof)"
echo -n "
                            3) "
printf "\e]8;;%s\a%s\e]8;;\a" "http://www.armantheparman.com/joinus" "We are separating money and state - Join us."
echo -n "
                            4) "
printf "\e]8;;%s\a%s\e]8;;\a" "http://www.armantheparman.com/fud" "Debunking Bitcoin FUD"
echo "

                 Have a nice day.
                    
		 To abort, type: (I'm sorry), then hit <enter>                 

########################################################################################
####################################################################################### 
"                  
read repent

if [[ $repent == "I'm sorry" ]] ; then break ; else echo -e "\nPlease wait patiently for computer to destroy itself, mwahaha! Or hit <enter> to have another go.\n" ; read ; continue ; fi

done

return 0

}
#slightly convoluted but allows exiting functionality to expand for later versions.
#clean_exit should be placed at code initial execution.
function clean_exit {

trap parmanode_clean_exit EXIT

}

function parmanode_clean_exit {

    tput sgr0 #resets colours of users terminal before quitting
    return 0
}
# added a debug function with slightly more complexity than
# a read command, to stop any arguments being passed to read
# without my knowledge. Only the character "d" will allow th
# code to contine.

function debug_point {

echo "$1"

while true
do
    echo "
debug point - hit "d" and <enter> to proceed."
read choice

if [[ $choice == "d" ]] ; then break ; fi
done
return 0
}
	
# searches for a string, then delete that line for all occurrances of the string.
# arguments should use full paths to file.

function delete_line {

input_file=$1
search_string=$2


	sed -i "/${search_string}/d" "$input_file" 

return 0
}
#functions here:
    # enter_continue
    # enter_exit
    # choose
    # invalid
    # previous menu
    # please wait

function enter_continue {
echo "Hit <enter> to continue." ; read
return 0
}

function enter_exit {
echo "Hit <enter> to exit." ; read
return 0
}

function choose {

if [[ $1 == "xpq" ]]
then
echo "Type your choice, or (p) for previous, (q) to quit, then <enter>: "
return 0
fi


if [[ $1 == "xq" ]]
then
echo "Type your choice, or (q) to quit, then <enter>: "
return 0
fi

if [[ $1 == "x" ]]
then
echo "Type your choice, then <enter>: "
return 0
fi

if [[ $1 == "epq" ]]
then
echo "Hit <enter> to continue, (p) for previous, (q) to quit, then <enter>: "
return 0
fi

return 0
}

function invalid {

set_terminal

echo "Invalid choice. Hit <enter> before trying again. " ; read
return 0
}

function previous_menu { 

echo "Hit <enter> to go back to the previous menu." ; read
return 0
}

function please_wait { 
set_terminal
echo "
Please wait, this will take a some time...
"
return 0
}
function error_BC100 {

echo "
########################################################################################

    ERROR BC100 - bitcoin.conf file creation failed (already exists)

########################################################################################

Aborting. Hit <enter>
"

enter_continue
return 0
}


function error_CF100 {
clear
echo "
########################################################################################    

                                    Error CF100

    Make sure Parmanode has been installed first (go to Add programs menu).
    
    Or, Parmanode may need to be re-insalled cleanly after uninstalling.

########################################################################################    
"
enter_continue
return 0

}


function error_i100 {

set_terminal
echo "
########################################################################################

                            Error i100 - Install Error 

########################################################################################

Hit <enter> to abort.
"
read
return 0
}

#USAGE:
#exit_choice ; if [[ $? ==1 ]]; then return 1 ; fi 

function exit_choice {
read choice

case $choice in

q|QUIT|Q|quit)
exit 0 ;;

p|P)
return 1 ;;

"")
return 0 ;;

esac
}function sudo_check {

while true ; do
set_terminal

if command -v sudo >/dev/null 2>&1

then break

else echo "
########################################################################################

                            Testing \"sudo\" checkpoint

    Parmanode has tested if the \"sudo\" command is available on your computer and it
    is not. The test failed. The program can not continue and will exit. Sudo is 
    necessary for certain commands that Parmanode will use, like mounting and 
    formatting the external drive. 

    If you can't get passed this checkpoint, you could try venturing into the world
    of learning to use the command line, and install sudo with the command:

                                 apt install sudo

    You will need to run this as the root user (no you can't run Parmanode as root).

########################################################################################
"
enter_exit ; break
fi

done
return 0
}

function gpg_check {

while true ; do

set_terminal
if command -v gpg >/dev/null 2>&1
then break

else echo "
########################################################################################

                            Testing \"gpg\" checkpoint

    Parmanode has tested if the \"gpg\" command is available on your computer and it
    is not. The test failed. The program can not continue and will exit. gpg is 
    necessary for certain commands that Parmanode will use, like verifying 
    signatures from developers who release their code. 

    Why did this happen? You may be running a minimalist version of gnu-Linux, as gpg
    is usually bundled together with Linux distributions.

    Parmanode can instal gpg for you if you like:

                              (gpg)      Install gpg

########################################################################################
"
choose "x"
read choice

#Install gpg
if [[ $choice != "gpg" ]] ; then exit 0 ; fi
set_terminal
sudo apt-get install gpg -y
enter_continue ; set_terminal
break
fi
done
return 0
}
function install_check { 
program_name=$1

    if grep -q "$1" $HOME/.parmanode/installed.conf 2>/dev/null

    then 
        install_error "$program_name"
        previous_menu
        return 1 

    else 
        return 0

    fi

}

function install_error {
program_name=$1
if [[ $program_name == "parmanode" ]] ; then

echo "
########################################################################################
	
                                    Install Error

            Parmanode cannot be re-installed unless fully uninstalled 
      	    first (there may be remnants which an proper uninstall will
            clearn up).

            If you're trying to add Bitcoin, or another program, go via
            the \"Add more programs\" menu.

########################################################################################
"
return 0

else
echo "

########################################################################################
                                    
                                    Install Error

    Previous installation detected. Please cleanly uninstall before trying again. 

    This is precaution to reduce the chance of errors.

########################################################################################
"
return 0
fi
}


function check_if_win7 {
# will return win7+, linux, or not_win string.
if [[ $(uname -s) == MINGW* ]] ; then
    version=$(wmic os get version | grep -oE "[0-9]+.[0-9]+")
    if (( $(echo "$version >= 6.1" | bc -l) )) ; then
        echo "win"
    else
        echo "win_old"
    fi
else
    echo "not_win"
fi
return 0
}


function which_os {
# Check if the OS is macOS
if [[ "$(uname -s)" == "Darwin" ]]
then
    echo "mac"
fi

# Check if the OS is Linux
if [[ "$(uname -s)" == "Linux" ]]
then
    echo "linux"
fi

# Check if the OS is Windows
if [[ "$(uname -s)" == "MINGW32_NT" || "$(uname -s)" == "MINGW64_NT" ]]
then
    x=$(check_if_win7)
    echo $x
    # will return win7+, linux, or not_win string.
fi
return 0
}
function set_terminal {

printf '\033[8;38;88t'
echo -e "\033[38;2;255;145;0m"

clear

return 0
}

function set_terminal_wide {

printf '\033[8;38;110t'

clear

return 0
}

function set_terminal_wider {

set_terminal

printf '\033[8;38;200t'

return 0
}
#function may not be in use.


function swap_string {

input_file=$1
output_file=/tmp/temp.txt
search_string=$2
replace_string=$3

# Find and replace the string in the input file, and save the result to the output file
sed "s/${search_string}/${replace_string}/g" "$input_file" > "$output_file"

# Replace the input file with the modified output file
mv "$output_file" "$input_file"
}

#####################

#This method replaces all occurrences of the search string in the input file. 
#If you want to replace only the first occurrence, remove the g flag in the sed command:

#sed "s/${search_string}/${replace_string}/g" "$input_file" > "$output_file"function update_computer {
#update computer

set_terminal
echo "
########################################################################################

          It is recommended that you update your operating system first.

########################################################################################

Do that now? y or n :" ; read choice

if [[ $choice == "y" || $choice == "Y" || $choice == "yes" ]]
then
    sudo apt-get update -y 2>/dev/null
    sudo apt-get upgrade -y 2>/dev/null

    #if user is running as root, above command may not work. Repeat without "sudo"
    apt-get update -y 2>/dev/null
    apt-get upgrade -y 2>/dev/null
echo "
"
enter_continue
fi
return 0
}
function menu_add_programs {
while true
do
set_terminal
echo "
########################################################################################

    Please select a program you'd like to add. Currently, only Bitcoin Core is
    available.

########################################################################################
          
                        b)        Bitcoin Core

            Not yet avaiable...                        

                        f)        Fulcrum (an Electrum Server)

                        m)        Mempool.Space

                        l)        LND

                        rtl)      RTL

                        bps)      BTCPay Server

                        s)        Specter Desktop

                        th)       ThunderHub

                        lh)       LND Hub

                        tor)      Tor 

########################################################################################

"
choose "xpq"

read choice

case $choice in
    B|b|bitcoin|Bitcoin)
        clear
        install_bitcoin
        return 0
        ;;
    q|Q|quit|QUIT)
        exit 0
        ;;
    p|P)
        return 0 
        ;;
    *)
        invalid
        continue
        ;;
esac
done

return 0

}
function menu_install {

while true
do
set_terminal
echo "
########################################################################################

                    i)          Install Parmanode

                    u)          Uninstall Parmanode

                    pp)         Parmanode Premium

                    a)          Add more programs

                    r)          Remove programs

########################################################################################
"
choose "xpq"

read choice

case $choice in
i)
    set_terminal
    install_parmanode ; if [$? == 0 ] ; then return 0 ; fi 
    continue
    ;;
u)
    set_terminal
    uninstall_parmanode
    continue
    ;;
pp)
    set_terminal
    premium
    continue
    ;;
a)
    set_terminal
    menu_add_programs
    return 0;;
r|R)
    remove_programs
    continue
    ;;
quit | QUIT | q | Q)
    exit 0
    ;;
p | P)
    return 0
    ;;
*)
    clear
    invalid #echo and confirm function. frequently used.
    continue;
    ;;

esac

done
return 0
}
function menu_parmanode {
clear
while true
do
set_terminal
echo "
########################################################################################

                                   Parmanode \"Apps\"

########################################################################################          

                             b)      Bitcoin Core

                             f)      Fulcrum (an Electrum Server)

                             m)      Mempool.Space

                             l)      LND

                             rtl)    RTL

                             bps)    BTCPay Server

                             s)      Specter Desktop

                             th)     ThunderHub

                             lh)     LND Hub

                             t)      Tor 

#######################################################################################

"
choose "xpq"
read choice

case $choice in

b|B)
    clear
    menu_bitcoin_core
    ;;
f | F | m | M | l | L | RTL | rtl | bps | BPS | s | S | th | TH | lh | LH | tor | TOR)
    clear
    echo "Not yet available. Stay tuned for future versions."
    echo "Hit <enter> to return to menu."
    read
    ;;
p)
    return 0
    ;;
q | Q | quit)
    exit 0
    ;;
*)
    invalid
    ;;
esac

done
}
#Refactored for Linux

function menu_startup {
set_terminal
while true
do
set_terminal
echo "
########################################################################################

                    (i)          Installation / Settings

                    (p)          Run Parmanode 

########################################################################################

"
choose "xq"
echo "
(Note, <enter> is the same as <return>)"
read choice

case $choice in
i)
    clear
    menu_install
    ;;

p)    
    menu_parmanode
    continue
    ;;

q | Q | quit)
    exit 0
    ;;
*)
    echo "

Invalid choice, try again. Hit <enter>"
    read

esac
done
}
function remove_programs {

while true ; do
set_terminal

echo "
########################################################################################

                                   Remove Programs


                             b)     Bitcoin Core
				  
########################################################################################

"
choose "xpq"
read choice

case $choice in

b|B)
uninstall_bitcoin
return 0
;;

p|P)
	return 0
	;;

q|Q|QUIT|quit|Quit)
	exit 0
	;;
*)
	invalid
	continue
	;;
esac

done

return 0
}
