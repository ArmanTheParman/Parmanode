function install_nostrrelay_explorer {

no_mac || { announce "If there is demand for Macs, it's up to you to let me know and I'll get on to it." ; return 1 ; }

if ! which make >/dev/null 2>&1 ; then
sudo apt-get update -y && sudo apt-get install make -y
fi

grep -q docker-end < $HOME/.parmanode/installed.conf || { announce "Must install Docker first.
" \
"Use menu: Add --> Other --> Docker). Aborting." && return 1 ; }

sned_sats

cd $hp
git clone --depth 1 https://github.com/gregorygmwhite/nostr-relay-explorer.git nostr_relay_explorer
cd nostr_relay_explorer

sed -i 's/3000:3000/3001:3001/g' docker-compose.yml
sed -i 's/8000/8050/g' docker-compose.yml

}