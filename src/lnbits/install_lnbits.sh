function install_lnbits {
if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi
grep -q docker-end < $HOME/.parmanode/installed.conf || { announce "Must install Docker first.
" \
"Use menu: Add --> Other --> Docker). Aborting." && return 1 ; }
grep -q lnd-end < $HOME/.parmanode/installed.conf || { announce "Please install LND first. Aborting." && return 1 ; }

set_terminal

mkdir $HOME/parmanode/lnbits 2>/dev/null
installed_config_add "lnbits-start"

cd $HOME/parmanode/
git clone --depth 1 https://github.com/lnbits/lnbits.git
cd lnbits
docker build -t lnbitsdocker/lnbits-legend .
cp .env.example .env
mkdir data
docker run --detach --publish 5000:5000 --name lnbits --volume ${PWD}/.env:/app/.env --volume ${PWD}/data/:/app/data lnbitsdocker/lnbits-legend \
|| { debug "failed to run lnbits image" && return 1 ; }

success "LNbits" "being installed."
installed_config_add "lnbits-end"
}