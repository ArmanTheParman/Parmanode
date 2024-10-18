function install_joinmarket {

grep -q "bitcoin-end" < $ic || { 
    announce "Please install Bitcoin first. Aborting." && return 1 
    }

jm_dependencies || return 1

make_jm_wallet || return 1

create_jm_user || return 1

create_jm_directories || return 1

success "JoinMarket has been installed"

}

function jm_dependencies {
set_terminal
echo "${green}Installing dependencies...${orange}"
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
echo "${green}Creating joinmarket wallet with Bitcoin Core/Knots...${orange}"
bitcoin-cli -named createwallet wallet_name=jm_wallet descriptors=false
enter_continue
}


function create_jm_user {
set_terminal
echo "${green}Creating joinmarket user...${orange}"
sudo adduser --disabled-password --gecos "" joinmarket >$dn 2>&1
sudo usermod -a -G $USER joinmarket >$dn 2>&1
enter_continue
}

function create_jm_directories {
set_terminal
echo "${green}Creating joinmarket directories and symplinks...${orange}"

sudo mkdir -p /home/joinmarket/.joinmarket #default dir where JM expects files. 
sudo chown -R joinmarket:joinmarket /home/joinmarket/.joinmarket
sudo ln -s $HOME/.bitcoin /home/joinmarket/.bitcoin
sudo chown -R joinmarket:joinmarket /home/joinmarket/.bitcoin
enter_continue
}