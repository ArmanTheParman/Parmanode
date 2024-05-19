function uninstall_nginx {
if [[ $OS == Mac ]] ; then brew services stop nginx ; brew uninstall nginx ; fi
if [[ $OS == Linux ]] ; then sudo systemctl stop nginx ; sudo apt-get purge nginx -y ; fi
installed_config_remove "nginx"
return 0
}