function old_install_jm {
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

do_install_joinmarket || return 1

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
    pkg-config libtool libgmp-dev libltdl-dev libssl-dev libatlas3-base libopenjp2-7 \
    software-properties-common

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
sudo -u joinmarket mkdir -p /home/joinmarket/.joinmarket #default dir where JM expects files. 
#sudo chown -R joinmarket:joinmarket /home/joinmarket/.joinmarket
sudo -u joinmarket ln -s $HOME/.bitcoin /home/joinmarket/.bitcoin
mkdir -p $hp/joinmarket
#sudo chown -R joinmarket:joinmarket /home/joinmarket/.bitcoin
enter_continue
}

function download_joinmarket {
set_terminal
echo -e "${green}Downloading JoinMarket...${orange}"
sudo -u joinmarket curl -L https://github.com/JoinMarket-Org/joinmarket-clientserver/releases/download/v0.9.11/joinmarket-clientserver-0.9.11.tar.gz.asc \
     -o /home/joinmarket/joinmarket-clientserver.tar.gz.asc
sudo -u joinmarket curl -L https://github.com/JoinMarket-Org/joinmarket-clientserver/archive/refs/tags/v0.9.11.tar.gz \
     -o /home/joinmarket/v0.9.11.tar.gz
}

function verify_joinmarket {
set_terminal
echo -e "${green}Verifying JoinMarket...${orange}"

#get pubkey
sudo curl https://raw.githubusercontent.com/JoinMarket-Org/joinmarket-clientserver/master/pubkeys/AdamGibson.asc | sudo gpg --import 
sudo curl https://raw.githubusercontent.com/JoinMarket-Org/joinmarket-clientserver/master/pubkeys/KristapsKaupe.asc | sudo gpg --import

if ! sudo gpg --verify /home/joinmarket/joinmarket-clientserver.tar.gz.asc /home/joinmarket/v0.9.11.tar.gz 2>&1 | grep -i good ; then
enter_continue "gpg verification ${red}failed${orange}. aborting."
return 1
else
enter_continue "GPG verification ${green}passed${orange}."
fi
}

function extract_joinmarket {
set_terminal
echo -e "${green}Extracting JoinMarket...${orange}"

sudo -u joinmarket tar -xvf /home/joinmarket/v0.9.11.tar.gz -C /home/joinmarket/

sudo mv /home/joinmarket/joinmarket-clientserver-0.9.11 /home/joinmarket/joinmarket
enter_continue
}

function do_install_joinmarket {
set_terminal
echo -e "${green}Installing JoinMarket...${orange}"
sudo -u joinmarket /home/joinmarket/joinmarket/install.sh --without-qt --disable-secp-check --disable-os-deps-check
enter_continue
}


function activation_script_joinmarket {
set_terminal
echo -e "${green}Running Joinmarket activate script...${orange}"
source $bc
sudo -u joinmarket bash -c "source /home/joinmarket/joinmarket/jmvenv/bin/activate && /home/joinmarket/joinmarket/scripts/wallet-tool.py"
enter_continue
sudo mv /home/joinmarket/.joinmarket/joinmarket.cfg $tmp/jm.cfg

delete_line "$tmp/jm.cfg" "rpc_cookie_file ="

gsed -i  "/rpc_wallet_file =/c\rpc_wallet_file = jm_wallet"     $tmp/jm.cfg
gsed -i  "/rpc_user =/c\rpc_user = $rpcuser"                    $tmp/jm.cfg
gsed -i  "/rpc_password =/c\rpc_password = $rpcpassword"        $tmp/jm.cfg
gsed -i  "/onion_serving_port =/c\onion_serving_port = 8077"    $tmp/jm.cfg

sudo cp $tmp/jm.cfg /home/joinmarket/.joinmarket/joinmarket.cfg
sudo chown joinmarket:joinmarket /home/joinmarket/.joinmarket/joinmarket.cfg
enter_continue
}