function compile_bitcoin {

sudo apt-get install make automake cmake curl g++-multilib libtool binutils bsdmainutils \
pkg-config python3 patch bison autoconf libboost-all-dev -y
debug "after install dependencies"

cd $hp || { echo "can't change directory. Aborting." ; enter_continue ; return 1 ; }
rm -rf ./bitcoin
if [[ $test == true ]] ; then
    debug "test true"
    if [[ -e $hp/bitcoin ]] ; then
        cd bitcoin
        git pull
        git checkout v26.0
    else
    git clone https://github.com/bitcoin/bitcoin.git 
    cd bitcoin
    git checkout v26.0
    fi

else
    debug "test not true"
    git clone https://github.com/bitcoin/bitcoin.git 
    cd bitcoin
    git checkout v26.0
fi


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

    If you saw no errors, hit <enter> to continue.

    Otherwise exit, and correct the error yourself, or report to Parman via Telegram 
    chat group for help.

########################################################################################
"
choose "epmq"
read choice
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
clear
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

make -j $j check && sudo make install
debug "after make check && make install"

success "bitcoin" "being compiled"

}