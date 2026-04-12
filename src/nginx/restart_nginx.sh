function restart_nginx {
if [[ $OS == "Mac" ]] ; then 
    sudo nginx -s reload
elif [[ $OS == "Linux" ]] ; then
    sudo systemctl restart nginx >$dn 2>&1
fi
return 0
}