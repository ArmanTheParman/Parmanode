function nostr_website_directory {
if [[ ! -d /var/www/website ]] ; then
set_terminal
sudo mkdir -p /var/www/website >/dev/null 2>&1
fi

sudo chown -R www-data:www-data /var/www/website
sudo find /var/www/website -type d -exec chmod 755 {} \; >/dev/null 2>&2
sudo find /var/www/website -type f -exec chmod 644 {} \; >/dev/null 2>&2
debug "after permissions"
}