function install_rtl {
if [[ $1 == "docker" ]] ; then install="docker" ; else install="host" ; fi

install_check "rtl" "install"

#if [[ $install == "host" ]] ; then 
#	install_nodejs 
#download_rtl
#	verify_rtl || return 1
#	extract_rtl
#install_rtl
#fi

mkdir $HOME/parmanode/rtl
make_rtl_config

docker build --build-arg USERNAME="$(whoami)" \
             --build-arg "USERID"=$(id -u) \
             -t rtl ./src/rtl/ || { debug1 "failed to build rtl image" && return 1 ; }

docker run -d --name rtl -p 3000:3000 \
                         -v $HOME/parmanode/rtl:/home/parman/RTL \
			 -v $HOME/.lnd:/home/$(whoami)/.lnd
                         --restart unless-stopped
        || { debug1 "failed to run rtl image" && return 1 ; }

rtl_password_changer

run_rtl

}