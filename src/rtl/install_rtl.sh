function install_rtl {

install_check "rtl" "install"

install_nodejs

download_rtl

verify_rtl || return 1

extract_rtl

install_rtl

make_rtl_config

}




function install_nodejs {
if [[ $OS == "Mac" ]] ; then brew install node ; return 0 ; fi




Linux_distro #gets Linux=Debian, Ubuntu, or Unknown

if [[ $OS == "Linux" ]] ; then

	if [[ $Linux == "Debian" || $Linux == "Ubuntu" ]] ; then

		curl -fsSL https://deb.nodesource.com/setup_20.x | bash - &&\
		apt-get install -y nodejs
	else
		set_terminal
		echo "Only supported for Debian/Ubuntu based distributions"
	fi
fi

mkdir $HOME/.npm-global
npm config set prefix '~/.npm-global'
delete_line "npm-global"
echo "export PATH=~/.npm-global/bin:\$PATH" >> $HOME/.profile
source $HOME/.profile

}

function download_rtl {

cd $HOME/parmanode
curl -LO https://github.com/Ride-The-Lightning/RTL/archive/refs/tags/v0.13.6.tar.gz
crul -LO https://github.com/Ride-The-Lightning/RTL/releases/download/v0.13.6/v0.13.6.tar.gz.asc

}


function verify_rtl {
cd $HOME/parmanode
curl https://keybase.io/suheb/pgp_keys.asc | gpg --import

if ! gpg --verify v0.13*.asc v0.13*.gz ; then
	set_terminal
	echo "GPG verification failed. Aborting."
	enter_continue
        return 1
	fi
}

function extract_rtl {
cd $HOME/parmanode
tar -xvf v0.13*.gz 
mv RTL-* RTL
}


function install_rtl {
cd $HOME/parmanode/RTL
npm install --omit=dev --legacy-peer-deps
}


function make_rtl_config {
cd $HOME/parmanode/RTL
mv Sample* RTL-Config.json
}

function set_rtl_password {

swap_string $HOME/parmanode/RTL/RTL-Config.json "multiPass" "\"multiPass\": \"$new_password\","

}
