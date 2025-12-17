function parmanode_variables {

if [[ $(uname) == "Linux" ]] ; then
    export OS="Linux" 
    export macprefix=""
    export torrc="/etc/tor/torrc"
    export varlibtor="/var/lib/tor"
elif [[ $(uname) == "Darwin" ]] ; then
    export OS="Mac"
    export macprefix="$(brew --prefix 2>/dev/null)" 
      if [[ -z $macprefix ]] ; then export macprefix="/usr/local" ; fi
    export parmanode_drive="/Volumes/parmanode"
    export torrc="$macprefix/etc/tor/torrc"
    export varlibtor="$macprefix/var/lib/tor"
fi

export dn="/dev/null"
export ndebug="$dp/.new_debug.log"
export nginxconf="$macprefix/etc/nginx/nginx.conf"
export parmaviewnginx="$macprefix/etc/nginx/conf.d/parmaview.conf"
export parmaviewdir="$macprefix/var/www/parmaview"
export parmanode_cert_dir="$macprefix/etc/ssl/parmanode"
export p4="$dp/p4.json"
export pvlog="$dp/parmaview/parmaview.log"
export errorlog="$dp/error.log"
export p4socketfile="/tmp/parmanode.sock"
export p4websocketfile="/opt/parmanode/parmanode_ws"
export socketbacklog="/opt/parmanode/socketbacklog"

# Enable alias expansion in non-interactive shells
shopt -s expand_aliases

export tmp="/tmp"

sudo -k

export xsudo=""

export PATH=$PATH:/usr/local/parmanode:/usr/local/bin/parmanode/
}