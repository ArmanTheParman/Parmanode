function install_thunderhub {
set_terminal
please_wait

install_nodejs
#make sure bitcoin installed
#make sure lightning running


cd $hp
git clone --depth 1 https://github.com/apotdevin/thunderhub.git
installed_conf_add "thunderhub-start"

export PORT=4000
npm install
npm run build && installed_conf_add "thunderhub-end" && success "Thunderhub" "being installed"
}

function start_thunderhub {
cd $pp/thunderhub
npm start
cd -
}

