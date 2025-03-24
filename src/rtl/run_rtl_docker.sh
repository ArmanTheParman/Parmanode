function run_rtl_podman {

if [[ $OS == Mac ]] ; then ports="-p 3000:3000" ; else ports="--network=host" ; fi

if [[ $special == "core_lightning" ]] ; then 

    vs="-v $HOME/.lightning:/home/parman/.lightning"
else

    vs="-v $HOME/.lnd:/home/parman/.lnd"
fi



podman run -d --name rtl $ports \
           --restart unless-stopped \
           -v $HOME/parmanode/rtl:/home/parman/RTL2 \
           $vs \
           -v $HOME/.parmanode/:/home/parman/.parmanode \
           rtl \
        || { announce "failed to run rtl image" ; return 1 ; }

}