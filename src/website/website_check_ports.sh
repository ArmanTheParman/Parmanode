
function website_check_ports {

if sudo netstat -tulnp | grep -q :80 ; then
if sudo netstat -tulnp | grep -q :80 | tail -n1 | grep -v nginx ; then
echo -e "
########################################################################################
    
    It looks like port 80 is already being used by this computer. This port is the 
    standard port for TCP internet traffic.

    Parmanode is not smart enough, yet, to install a website on other funky ports. 
    Aborting.

########################################################################################
" 
enter_continue
return 1
fi
fi

if sudo netstat -tulnp | grep -q :443  ; then
if sudo netstat -tulnp | grep -q :443 | tail -n1 | grep -v nginx ; then
echo -e "
########################################################################################
    
    It looks like port 443 is already being used by this computer. This port is the 
    standard port for SSL internet traffic.

    Parmanode is not smart enough, yet, to install a website on funky ports. Aborting.

########################################################################################
" 
enter_continue
return 1
fi
fi

}
