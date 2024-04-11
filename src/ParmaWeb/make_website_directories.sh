function make_website_directories {
if [[ ! -d /var/www/website ]] ; then
set_terminal
sudo mkdir -p /var/www/website >/dev/null 2>&1
fi
}