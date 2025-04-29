function install_cgi {
grep -q "cgi-end" $ic || return 0
yesorno "Do you want to enable the browser-based CGI interface?" || return 1
install_nginx
install_fastcgi
success "CGI interface for browser access enabled. User IP address and port 54000"
}

function install_fcgiwrap {
sudo apt update
sudo apt install -y fcgiwrap
sudo systemctl enable --now fcgiwrap
}

function uninstall_cgi {
yesorno "Do you want to disable the browser-based CGI interface?" || return 1
sudo apt remove -y fcgiwrap
installed_conf_add "cgi-end"
success "CGI interface for browser access disabled"
}