function parmanode_variables {
#These are mostly custom variables that are loaded to make the code easier to write

#DEBUG
#This part checks to enter debugging mode. Mainly for developing, not client usage
#Can be enabled by adding "d" or "debug" as an argument to the run script.
#If debug is 1, then a debuging function becomes active, which pauses the
#program wherever it appears. "export" keeps variable in global memory.
if [[ $1 == "debug" || $1 == d || $2 == d || $2 == "debug" ]] ; then export debug=1 
elif [[ $1 == d2 ]] ; then export debug=2  
elif [[ $1 == d3 ]] ; then export debug=3  #bre docker no-cache build
fi

#Can be used to source parmanode script and then open a bash terminal with the functions
#loaded. Eg 'rp bash'. Good for testing.
if [[ $1 == bash ]] ; then export bash=1 ; fi

#used for debugging
if [[ $1 == skipverify || $2 == skipverify || $3 == skipverify ]] ; then export verify=skip ; fi

#Deprecated variable, but doesn't hurt to leave it just in case.
#save position of working directory. 
export original_dir=$(pwd) >/dev/null 2>&1

#Using $() can run some code inside and the output is then a string.
#Here, $(uname) returns either "Linux" or "Darwin" for Macs.
if [[ $(uname) == "Linux" ]] ; then
    export parmanode_drive="/media/$USER/parmanode"
    export bashrc="$HOME/.bashrc"
    export macprefix=""
    export torrc="/etc/tor/torrc"
    export varlibtor="/var/lib/tor"
elif [[ $(uname) == "Darwin" ]] ; then
    export macprefix="$(brew --prefix 2>/dev/null)" ; if [[ -z $macprefix ]] ; then export macprefix="/usr/local" ; fi
    export parmanode_drive="/Volumes/parmanode"
    export bashrc="$HOME/.zshrc"
    export torrc="$macprefix/etc/tor/torrc"
    export varlibtor="$macprefix/var/lib/tor"
fi

export pdc="$HOME/.parmanode/parmadrive.conf"
export pd=$parmanode_drive
export dp="$HOME/.parmanode"
export hp="$HOME/parmanode"
export pp="$HOME/parman_programs"
export pn="$pp/parmanode"
export db="$HOME/.bitcoin"
export bc="$db/bitcoin.conf"
export fc="$HOME/.fulcrum/fulcrum.conf"
export hm="$dp/hide_messages.conf"
export pc="$dp/parmanode.conf"
export ic="$dp/installed.conf"
export oc="$dp/overview.conf"
export nk="$dp/.nostr_keys/nostr_keys.txt"
export nkd="$dp/.nostr_keys"
export dn="/dev/null"
export ndebug="$dp/.new_debug.log"
export parmaviewnginx="$macprefix/etc/nginx.conf.d/parmaview.conf"
export wwwparmaviewdir="$macprefix/var/www/parmaview

if [[ -z $dn ]] ; then echo "some problem with dn variable" ; read ; fi ##debug

if [[ -z $lnd_port ]] ; then export lnd_port=9735 ; fi 

#CGI will not have everything source at this point
[[ $cgi == "true" ]] || get_Mac_version #function to export Mac Version variables (Need Mav version 10.9 or later)
[[ $cgi == "true" ]] || get_ip_address #function to put the IP address of the computer in memory.

# A counter for the number of times main_menu has been 'Inceptioned'.
# back2main function will add 1. After a set value, user is warned to restart Parmanode.
export main_loop=0

#bash version
[[ $cgi == "true" ]] || export bashV_major=$(bash --version | head -n1 | cut -d \. -f 1 | grep -Eo '[0-9]+')

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

#if parmanode.conf gets corrupted, this makes sure the OS variable exists
if ! grep -q "OS=" $pc >/dev/null 2>&1 ; then
which_os
fi

#Premium Configs
export PTWINCONF=$hp/parmatwin/parmatwin.conf
export PSCONFIG=$hp/parmasync/parmasync.conf
}