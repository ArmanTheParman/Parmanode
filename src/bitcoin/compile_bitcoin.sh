function compile_bitcoin {

sudo apt-get install make automake cmake curl g++-multilib libtool binutils bsdmainutils pkg-config python3 patch bison autoconf
debug "after install dependencies"

cd $hp || { echo "can't change directory. Aborting." ; enter_continue ; return 1 ; }
rm -rf ./bitcoin
mkdir bitcoin

git clone https://github.com/bitcoin/bitcoin.git bitcoin_github
cd bitcoin
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
echo "
########################################################################################

    Parmanode will be running the command...

      ./configure $options --with-gui=no

    Hit$green hfsp$orange to change the final option to --with-gui=yes

########################################################################################
"
choose "xpmq"
read choice
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;
hfsp|HFSP)
export gui="--with-gui=yes"
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

    The command that will be run is...

    ./configure $options $gui

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
debug "after configure"

while true do
clear
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
if [[ $choice != o ]] ; then j=$(nproc) ; fi

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