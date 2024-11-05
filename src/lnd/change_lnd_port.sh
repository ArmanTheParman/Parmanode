function change_lnd_port {

if grep -r "lnddocker-" < $ic ; then
announce "It is not possible to change the LND port if running inside
    a Docker container, as the ports are already 'bound' when running
    the container. 9735 it shall remain. 
    
    To change, you'd have to re-install LND yourself without Parmanode. 
    Aborting."
    return 1
fi

set_lnd_port || return 1
get_extIP

if grep -q "litd" < $ic ; then

sudo gsed -i "/externalip=/c\lnd.externalip=$extIP:$lnd_port"       $HOME/.lit/lit.conf
sudo gsed -i "/listen=0.0.0.0:973/c\lnd.listen=0.0.0.0:$lnd_port"   $HOME/.lit/lit.conf

else

sudo gsed -i "/externalip=/c\externalip=$extIP:$lnd_port"      $HOME/.lnd/lnd.conf
sudo gsed -i "/listen=0.0.0.0:973/c\listen=0.0.0.0:$lnd_port"  $HOME/.lnd/lnd.conf

fi

restart_lnd
return 0
}