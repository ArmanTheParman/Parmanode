function make_tor_script_mac {

#If brew installed on mac, but not tor, install tor in the background with crontab
#Once it's installed the crontab entry is deleted. A flag is added in the entry for selective search and delete later.
#If the tor install fails, can let crontab keep trying to install every minute. So, REMOVE_TOR_FLAG file added
#at the end of the script to prevent it running.

if [[ $OS != Mac ]] ; then return 0 ; fi
if ! which brew >/dev/null ; then return 0 ; fi

enable_tor_general_mac

if which tor >/dev/null || [[ -e $dp/REMOVE_TOR_FLAG ]] ; then 
brew services restart tor >/dev/null 2>&1
sudo /bin/cat /etc/crontab | sudo /usr/bin/sed '/REMOVE_TOR_FLAG/d' | sudo /usr/bin/tee /tmp/crontab >/dev/null && \
sudo /bin/mv /tmp/crontab /etc/crontab && \
rm $dp/REMOVE_TOR_FLAG >/dev/null 2>&1
return 0
fi

cat << EOF > $dp/tor_script.sh
#!/bin/bash

export USER=$USER
export HOME=$HOME
export PATH=$PATH

if ! which brew ; then return 0 ; fi
if which tor ; then return 0 ; fi

/usr/local/bin/brew install tor > $dp/debug.log 2>&1 && \
  if ! grep "tor-end" < $ic ; then echo "tor-end" >> $ic ; fi

touch $dp/REMOVE_TOR_FLAG
EOF

sudo chmod +x $dp/tor_script.sh

echo "* * * * * $USER [ -x $HOME/.parmanode/tor_script.sh ] && $HOME/.parmanode/tor_script.sh #REMOVE_TOR_FLAG" | sudo tee -a /etc/crontab >/dev/null 2>&1
}

