function parmanode_variables {
#The following code checks if in debugging mode. Mainly for developing, not client usage
#If debug is 1, then a debuging function becomes active, which pauses the
#program wherever it appears. "export" keeps variable in global memory.
if [[ $1 == "debug" || $1 == d || $2 == d || $2 == "debug" ]] ; then export debug=1 
elif [[ $1 == d2 ]] ; then export debug=2  
elif [[ $1 == d3 ]] ; then export debug=3  #bre docker no-cache build
elif [[ $1 == d4 ]] ; then export debug=4  
elif [[ $1 == d5 ]] ; then export debug=5  
elif [[ $1 == d6 ]] ; then export debug=6  
elif [[ $1 == d7 ]] ; then export debug=7  
fi

# So args are univerally available
export arg1=$1
export arg2=$2
export arg3=$3

if [[ $1 == bash ]] ; then export bash=1 ; fi
if [[ $1 == m  ]] ; then export debug=menu ; export skip_intro="true" ; fi
if [[ $1 == fix ]] ; then export fix=1; fi
if [[ $1 == report ]] ; then export report="true" ; fi
if [[ $1 == test || $2 == test ]] ; then export test=1; fi

#used for debugging
if [[ $1 == skipverify || $2 == skipverify || $3 == skipverify ]] ; then export verify=skip ; fi

#save position of working directory. "Export" makes the variable available everywhere.
export original_dir=$(pwd) >/dev/null 2>&1

if [[ $(uname) == Linux ]] ; then
export parmanode_drive="/media/$USER/parmanode"
export bashrc="$HOME/.bashrc"
export macprefix=""
export torrc="/etc/tor/torrc"
export varlibtor="/var/lib/tor"
elif [[ $(uname) == Darwin ]] ; then
export parmanode_drive="/Volumes/parmanode"
export bashrc="$HOME/.zshrc"
export macprefix="/usr/local"
export torrc="/usr/local/etc/tor/torrc"
export varlibtor="/usr/local/var/lib/tor"
fi
export pd=$parmanode_drive

export dp="$HOME/.parmanode"
export hp="$HOME/parmanode"
export pp="$HOME/parman_programs"
export pn="$pp/parmanode"
export db="$HOME/.bitcoin"
export bc="$db/bitcoin.conf"
export fc="$hp/fulcrum/fulcrum.conf" 
export hm="$dp/hide_messages.conf"

export parmanode_conf="${dp}/parmanode.conf"
export installed_conf="${dp}/installed.conf"
export pc=$parmanode_conf
export ic=$installed_conf
export oc="$dp/overview.conf"
export hm="$dp/hide_messages.conf"
export drive_programs="bitcoind fulcrum electrs electrumx"
export nk="$dp/.nostr_keys/nostr_keys.txt"
export nkd="$dp/.nostr_keys"
export dn="/dev/null"

if [[ -z $lnd_port ]] ; then export lnd_port=9735 ; fi #Line added version 3.14.1

get_Mac_version #function to export Mac Version variables

get_ip_address #function to put the IP address of the computer in memory.

# A counter for the number of times main_menu has been 'Inceptioned'.
# back2main function will add 1. After a set value, user is warned to restart Parmanode.
export main_loop=0

#bash version
export bashV_major=$(bash --version | head -n1 | cut -d \. -f 1 | grep -Eo '[0-9]+')

#for gnu-sed on macs - seems to not be necessary - note it only works withing Parmanode,
#it wont' work in the normal terminal.
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

# Enable alias expansion in non-interactive shells
shopt -s expand_aliases

if [[ -d "/tmp" ]] ; then
    export tmp="/tmp"
elif [[ -d "$HOME/tmp" ]] ; then
    export tmp="$HOME/tmp" 
else
   mkdir -p $HOME/tmp >/dev/null 2>&1
   export tmp="$HOME/tmp" 
fi

}

function print_parmanode_variables {

echo debug $debug fix $fix test $test bash $bash
echo original dir $original_dir
echo parmanode dirve $parmanode_drive
echo bashV_major $bashV_major

}