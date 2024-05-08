function lnd_docker_run {

text="-v $HOME/.bitcoin:/home/parman/.bitcoin"

#break out of loop only if .bitcoin exists or if selected
while true ; do

if [[ ! -e $HOME/.bitcoin ]] ; then 

set_terminal ; echo -e "
########################################################################################

    The$cyan ~/.bitcoin$orange data directory could not be detected. If it should
    be on an external drive, then ~/.bitcoin would be a symlink to the drive. 
$yellow
    Perhaps the drive is not connected or mounted?
$orange
    Would you like to let Parmanode continue and$red not volume mount$orange this directory to the
    LND container? It could cause unexpected behaviour, but you know what you're
    doing right?
$red
                     1)    Continue, I got this. (Skip mounting .bitcoin)
$orange
                     2)    Abort
$green
                     3)    Let me fix some thing and let Parmanode test again 
$orange
########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P|2|a) return 1 ;;
1)
unset text
break
;;
3)
continue ;;
*) 
invalid ; continue ;;
esac
fi
break
done

#$text will be empty if user chooses #3 and .bitcoin doesn't exists,
#othersie it will mount .bitcoin
# port 10009 on the host to send traffic to lnd. 10010 on the container side to avoid port conflic.
# 10010 redicrected to 10009 inside container with reverse proxy stream
if ! docker ps | grep -q lnd ; then
docker run -d --name lnd \
           -v $HOME/.lnd:/home/parman/.lnd $text \
           -v $HOME/parmanode/lnd:/home/parman/parmanode/lnd \
           -p 9735:9735 \
           -p 8080:8080 \
           -p 10009:10010 \
           lnd
fi
}

### Not needed because using host.docker.internal in lnd.conf
#           -p 28332:28332 \
#           -p 28333:28333 \

###
## port 8332 needed too, but can't "bind", managed with reverse proxy stream