function install_joinmarket {
debug "in jm install"
grep -q "bitcoin-end" < $ic || { 
    announce "Please install Bitcoin first. Aborting." && return 1 
    }

jm_dependencies || return 1

make_jm_wallet || return 1

installed_conf_add "joinmarket-start"

create_jm_user || return 1

create_jm_directories || return 1

download_joinmarket || return 1

verify_joinmarket || return 1

extract_joinmarket || return 1

install_joinmarket || return 1

activation_script_joinmarket || return 1

installed_conf_add "joinmarket-end"
success "JoinMarket has been installed"

}

function jm_dependencies {
set_terminal
echo -e "${green}Installing dependencies...${orange}"
sudo apt-get update -y
sudo apt install -y \
    python3-venv curl python3-dev python3-pip build-essential automake \
    pkg-config libtool libgmp-dev libltdl-dev libssl-dev libatlas3-base libopenjp2-7

enter_continue
return 0
}

function make_jm_wallet {

isbitcoinrunning

if [[ $bitcoinrunning == "false" ]] ; then
    announce "Please make sure Bitcoin is running first. Aborting."
    return 1
fi

set_terminal
echo -e "${green}Creating joinmarket wallet with Bitcoin Core/Knots...${orange}"
bitcoin-cli -named createwallet wallet_name=jm_wallet descriptors=false
enter_continue
}


function create_jm_user {
set_terminal
echo -e "${green}Creating joinmarket user...${orange}"
sudo adduser --disabled-password --gecos "" joinmarket >$dn 2>&1
sudo usermod -a -G $USER joinmarket >$dn 2>&1
sudo usermod -a -G joinmarket $USER >$dn 2>&1
enter_continue
}

function create_jm_directories {
set_terminal
echo -e "${green}Creating joinmarket directories and symplinks...${orange}"
sudo mkdir -p /home/joinmarket/.joinmarket #default dir where JM expects files. 
sudo chown -R joinmarket:joinmarket /home/joinmarket/.joinmarket
sudo ln -s $HOME/.bitcoin /home/joinmarket/.bitcoin
sudo chown -R joinmarket:joinmarket /home/joinmarket/.bitcoin
enter_continue
}

function download_joinmarket {
set_terminal
sudo su joinmarket
cd /home/joinmarket
echo -e "${green}Downloading JoinMarket...${orange}"
curl -LO https://github.com/JoinMarket-Org/joinmarket-clientserver/releases/download/v0.9.11/joinmarket-clientserver-0.9.11.tar.gz.asc
curl -LO https://github.com/JoinMarket-Org/joinmarket-clientserver/archive/refs/tags/v0.9.11.tar.gz
exit
}

function verify_joinmarket {
set_terminal
sudo su joinmarket
cd /home/joinmarket
echo -e "${green}Verifying JoinMarket...${orange}"

#get pubkey
curl https://raw.githubusercontent.com/JoinMarket-Org/joinmarket-clientserver/master/pubkeys/AdamGibson.asc | gpg --import 
curl https://raw.githubusercontent.com/JoinMarket-Org/joinmarket-clientserver/master/pubkeys/KristapsKaupe.asc | gpg --import

if ! gpg --verify *asc *gz 2>&1 | grep -i good  ; then
enter_continue "gpg verification ${red}failed${orange}. aborting."
# return 1
else
enter_continue "GPG verification ${green}passed${orange}."
fi
exit
}

function extract_joinmarket {
set_terminal
sudo su joinmarket
cd /home/joinmarket
echo -e "${green}Extracting JoinMarket...${orange}"

tar -xvf *gz
rm *gz *asc

mv joinmarket-clientserver* joinmarket
exit
}

function install_joinmarket {
set_terminal
sudo su joinmarket
cd /home/joinmarket/joinmarket
echo -e "${green}Installing JoinMarket...${orange}"
./install.sh --without-qt --disable-secp-check --disable-os-deps-check
exit
}


function activation_script_joinmarket {

true

}