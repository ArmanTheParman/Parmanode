function compile_bitcoin {
if [[ $version == self ]] ; then return 0 ; fi

#menu choices carried in by variables.
set_terminal #clear
if [[ $bitcoin_compile == "false" ]] ; then debug "exiting compile function" ; return 0 ; fi

#to reduce errors on scrren, making temporary git variables...
export GIT_AUTHOR_NAME="Temporary Parmanode"
export GIT_AUTHOR_EMAIL="parman@parmanode.parman"
export GIT_COMMITTER_NAME="Parmanode Committer"
export GIT_COMMITTER_EMAIL="parman@parmanode.parman"

echo -e "${pink}Upgrading, and installing dependencies to compile bitcoin...$orange"
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get --fix-broken install -y
sudo apt-get install make automake cmake curl g++-multilib libtool binutils bsdmainutils -y
sudo apt-get install pkg-config python3 patch bison autoconf libboost-all-dev autoconf -y
sudo apt-get install imagemagick -y
sudo apt-get install librsvg2-bin -y


cd $hp || { echo "can't change directory. Aborting." ; enter_continue ; return 1 ; }

if [[ $bitcoin_compile == "true" ]] ; then
debug "in compile true" #pause to check screen ouput

if [[ -e $hp/bitcoin_github ]] ; then 
cd $hp/bitcoin_github 
# start fresh from master, but not have to re-download every time I test
git stash ; git checkout master ; git branch -D parmanode_ordinals_patch 2>/dev/null
git pull 
else
git clone https://github.com/bitcoin/bitcoin.git bitcoin_github
cd $hp/bitcoin_github
fi

if [[ $version == "choose" ]] ; then # nested level 2 if

while true ; do
set_terminal ; echo -e "
########################################################################################

    Which version of Bitcoin Core do you want?


                            25)    v25.0
$green
                            26)    v26.0 
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

#apply ordinals patch to v25 or v26
    if [[ $ordinals_patch == "true" ]] ; then
        git checkout -b parmanode_ordinals_patch
        curl -LO https://gist.githubusercontent.com/luke-jr/4c022839584020444915c84bdd825831/raw/555c8a1e1e0143571ad4ff394221573ee37d9a56/filter-ordinals.patch 
        git apply filter-ordinals.patch
        git add . ; git commit -m "ordinals patch applied"
        debug "patch applied"
    fi

fi #end level 2 if 

elif [[ $knotsbitcoin == true ]] ; then  #compile bitcoin not true

    if [[ -e $hp/bitcoinknots_github ]] ; then 
        cd $hp/bitcoinknots_github ; git checkout $version ; debug "after checkout knots version, $version"
    else
        cd $hp && git clone https://github.com/bitcoinknots/bitcoin.git bitcoinknots_github && cd bitcoinknots_github
        git checkout $version ; debug "version for knots is $version"
    fi

fi #end if compile true, and elif knotsbitcoin
unset GIT_AUTHOR_NAME
unset GIT_AUTHOR_EMAIL
unset export GIT_COMMITTER_NAME
unset export GIT_COMMITTER_EMAIL

debug "after clone"

./autogen.sh
debug "after autogen"

while true ; do
set_terminal ; echo -e "
########################################################################################

    Bitcoin can be compiled with or without a Graphical User Interfact (GUI).

    Parmanode does not use a GUI, as it is itself the interface between you and the
    node's functions - this is partly what Parmanode is for.

    If you want a GUI, you can opt for that, but you might get unpredictable behaviour
    as I have not designed Parmanode for this to be used in parallel.

    You have choices...
$green
              1)   Compile Bitcoin WITHOUT a GUI (recommended, and faster) 
$red
              2)   Compile bitcoin WITH a GUI
$orange
########################################################################################
"
choose "xpmq" ; read choice
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
1) gui=no ; break ;;
2) gui=yes ; 
sudo apt-get install -y qtcreator qtbase5-dev qt5-qmake 
break ;;
*) invalid ;;
esac
done


while true ; do
clear ; echo -e "
########################################################################################

   The configure command that will be run is the following: 
$cyan
   ./configure --with-gui=$gui
$orange

   Hit$green <enter>$orange to continue, or,$yellow type in$orange additional options you
   may have researched yourself and would like to include, then hit$green <enter>$orange

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

set_terminal

./configure $options --with-gui=$gui

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
$cyan
    Running tests.$orange Will only take a few minutes. 
    To see the output in realtime, you can open a new terminal and type:
$green
    tail -f ~/.parmanode/bitcoin_compile_check.log
$orange
    Then hit $cyan<control>-c$orange to stop it.

########################################################################################

"
enter_continue
please_wait_no_clear

sudo make -j $j check > $dp/bitcoin_compile_check.log

echo -e "$orange
########################################################################################

    Tests done. Hit $cyan<enter>$orange to continue on to the installation (copies binaries
    to system wide directories).

    If you saw errors, hit$cyan x$orange to abandon the installation. You would need 
    to then uninstall the partial bitcoin installation before you can try again.

    Note: If you selected ordinals patch, then some transaction tests failing would
    be normal. Carry on.

    For Knots Bitcoin, if you see some bitcoin.ico error, it's probably safe to 
    continue, it's just an icon file.

########################################################################################
"
choose "xpmq"
read choice
clear
case $choice in
q|Q) exit 0 ;; p|P|M|m|x|X) back2main ;;
esac

sudo make install
debug "after make check && make install"
}