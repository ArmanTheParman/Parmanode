function compile_bitcoin {
if [[ $compile_bitcoin == "false" ]] ; then debug "exiting compile function" ; return 0 ; fi
clear
echo "installing dependencies to compile bitcoin..."
sleep 1

sudo apt-get install make automake cmake curl g++-multilib libtool binutils bsdmainutils \
pkg-config python3 patch bison autoconf libboost-all-dev -y

cd $hp || { echo "can't change directory. Aborting." ; enter_continue ; return 1 ; }


if [[ $bitcoin_compile == "true" ]] ; then
debug "in compile true"

if [[ -e $hp/bitcoin_github ]] ; then cd $hp/bitcoin_github && git pull 
else
git clone https://github.com/bitcoin/bitcoin.git bitcoin_github
fi

cd $hp/bitcoin_github

if [[ $version == "choose" ]] ; then # nested level 2 if

while true ; do
clear ; echo -e "
########################################################################################

    Which version of Bitcoin Core do you want?


                            25)    v25.0
$green
                            26)    v26.0 (latest reslease)
$orange

########################################################################################
"
choose "x" ; read choice
case $choice in
    25) 
    export version="v25.0" ; break ;;
    26)
    export version="v26.0" ; break ;;
    *)
    invalid ;;
esac
done
if [[ $version == "latest" ]] ; then export version="master" ; fi
git checkout $version

#apply ordinals patch
    if [[ $ordinals_patch == "true" ]] ; then
        curl -LO https://gist.githubusercontent.com/luke-jr/4c022839584020444915c84bdd825831/raw/555c8a1e1e0143571ad4ff394221573ee37d9a56/filter-ordinals.patch 
        git apply filter-ordinals.patch
        debug "patch applied"
    fi

fi #end level 2 if version choose

elif [[ $knotsbitcoin == true ]] ; then  #compile bitcoin not true

    if [[ -e $hp/bitcoinknots_github ]] ; then 
        cd $hp/bitcoinknots_github ; git checkout $version ; debug "after checkout knots version, $version"
    else
        cd $hp && git clone https://github.com/bitcoinknots/bitcoin.git bitcoinknots_github && cd bitcoinknots_github
        git checkout $version ; debug "version for knots is $version"
    fi

fi #end if compile true, and elif knotsbitcoin

debug "after clone"

./autogen.sh
debug "after autogen"

while true ; do
clear ; echo -e "
########################################################################################

   The configure command that will be run is the following: 
$green
   ./configure --with-gui=no
$orange
   If you want to add any additional options, type them in, then hit <enter>,
   otherwise, just hit <enter>

   If you really want the gui, you can change that option a bit later.

########################################################################################
"
read options
clear
case $options in
"") break ;;
*)
clear
echo -e "
########################################################################################

    You have entered $options

    Hit y to accept, or n to try again.

########################################################################################
"
    read choice
    case $choice in
    y) break ;; *) continue ;;
    esac
;;
esac
done

while true ; do
clear
echo -e "
########################################################################################

    Parmanode will be running the command...
$green
      ./configure $options --with-gui=no
$orange
    Hit$green hfsp$orange to change the final option to --with-gui=yes

########################################################################################
"
choose "xpmq"
set_terminal
read choice
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;
hfsp|HFSP)
export gui="--with-gui=yes"
clear 
sudo apt install -y qtcreator qtbase5-dev qt5-qmake 
debug "after install qt5"
break
;;
*)
export gui="--with-gui=no"
break
;;
esac
done
clear
echo -e "
########################################################################################

    The command, now final, that will be run is...
$green
    ./configure $options $gui
$orange
########################################################################################
"
choose "epmq"
read choice 
case $choice in
q|Q) exit 0 ;; p|P|m|M) back2main ;;
esac
clear


echo -e "
Please wait...

"
sleep 5 

./configure $options $gui

echo -e "
########################################################################################

    If you saw no errors, hit $cyan<enter>$orange to continue.

    Otherwise exit, and correct the error yourself, or report to Parman via Telegram 
    chat group for help.

########################################################################################
"
choose "epmq"
read choice
set_terminal
case $choice in
q|Q) exit ;; p|P|M|m) back2main ;;
esac

while true ; do
set_terminal
# j will be set to $(nproc) or user choice
echo -e "
########################################################################################

    Running make command...
$green
    make -j $(nproc)
$orange
    If you would like to override the j value, hit 'o' now, otherwise hit <enter>
    to continue.

$pink
    FYI, the j value is the number of core processors to use to compile. Parmanode
    has worked out the max value for you.
$orange
########################################################################################
"
read choice
if [[ $choice != o ]] ; then j=$(nproc) ; break ; fi

clear
echo -e "
########################################################################################

    Please enter the$green j$orange value you wish to use, then hit enter.

########################################################################################
"
read j
set_terminal
echo -e "
########################################################################################

    You have chosen $j for the j value. <enter> to continue, or$cyan n$orange and <enter> 
    to try again.

########################################################################################
"
read choice2
if [[ $choice2 == "" ]] ; then break ; fi
done
clear
echo "Running make command, please wait..."
sleep 3

make -j $j
debug "after make"

set_terminal
echo -e "
########################################################################################

Running tests. Open a new terminal and type ...
$green
tail -f ~/.parmanode/bitcoin_compile_check.log
$orange
... to see the output in real time. Then hit $cyan<control>-c$orange to stop it.

########################################################################################

"
enter_continue

sudo make -j $j check > $dp/bitcoin_compile_check.log

echo -e "
########################################################################################
    Tests done. Hit $cyan<enter>$orange to continue on to the installation (copies binaries
    to system wide directories).

    If you saw errors, hit$cyan x$orange to abandon the installation. You need to then 
    uninstall the partial bitcoin installation before you can try again.

    Note: If you selected ordinals patch, then some transaction tests failing would
    be normal. Carry on.
########################################################################################
"
choose "xpmq"
read choice
case $choice in
q|Q) exit 0 ;; p|P|M|m|x|X) back2main ;;
esac

sudo make install
debug "after make check && make install"
success "bitcoin" "being compiled"
}