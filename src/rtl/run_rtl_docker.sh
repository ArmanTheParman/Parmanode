function run_rtl_docker {

if [[ $OS == Mac ]] ; then ports="-p 3000:3000" ; else ports="--network=host" ; fi

docker run -d --name rtl $ports \
           --restart unless-stopped \
           -v $HOME/parmanode/rtl:/home/parman/RTL2 \
           -v $HOME/.lnd:/home/parman/.lnd \
           -v $HOME/.parmanode/:/home/parman/.parmanode \
           rtl \
        || { announce "failed to run rtl image" ; return 1 ; }

}