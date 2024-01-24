function bitcoin_compile_instructions {

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                       How to compile Bitcoin from scratch
$orange
########################################################################################
    
    So you want to do this. Very cool. I'll show you how. Open a separate terminal
    and follow these steps sequencially. Choose the items you want to read more...

    STEPS:

$green                   1)$orange        Update your system
$green                   2)$orange        Install all the necessary dependencies
$green                   3)$orange        Git clone Bitcoin repository and checkout
$green                   4)$orange        Apply the ordinals patch if you want that
$green                   5)$orange        Run autogen
$green                   6)$orange        Run configure with desired options
$green                   7)$orange        Run the make command
$green                   8)$orange        Run make check
$green                   9)$orange        Run make install

$cyan
    Once you have finished, hit$green <enter>$cyan to exit the installation. You can
    then start over and choose to import the binary files you have made.
$orange

########################################################################################
"
choose "xpmq"
read choice
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;
"") 
return 1 ;;
1)
set_terminal ;
echo -e "
########################################################################################
$cyan
                            UPDATE YOUR SYSTEM
$orange                            
    Run these commands to update your system. It's a good idea to do it regularly
    anyway...
$green
        sudo apt-get update

        sudo apt-get upgrade
$orange
    Someimtes in the output, you might see a recommendation to do one of the following 
    commands which you should do...
$green
        sudo apt-get --fix-broken install 

        sudo apt-get autoremove 
$orange
########################################################################################       
"
enter_continue
set_terminal
;;
2)
set_terminal_wide ; echo -e "
##############################################################################################################
$cyan
                                         INSTALL DEPENDENCIES
$orange
    Dependencies are programs or libraries (files with code) thare are required for a given program to 
    work. To compile bitcoin, you'll need a few things.

    Here are the command to install it all. I have split up the installation of dependencies to multiple 
    commands for readability, but it can be done all in one go. Pay attention to any errors (The '-y'
    option will automatically answer yes to the expected confirmation question).
$green
    sudo apt-get install make automake cmake curl g++-multilib libtool binutils bsdmainutils -y

    sudo apt-get install pkg-config python3 patch bison autoconf libboost-all-dev autoconf -y

    sudo apt-get install qtcreator qtbase5-dev qt5-qmake -y $orange #Needed for Bitcoin-QT (GUI)$green

    sudo apt-get install imagemagick -y  $orange                    #Needed if installing Knots Bicoin$green

    sudo apt-get install librsvg2-bin -y $orange                    #Needed if installing Knots Bicoin$green
$orange
##############################################################################################################
"
enter_continue
;;
3)
set_terminal ; echo -e "
########################################################################################
$cyan
                         CLONE THE BITCOIN REPOSITORY
$orange                    
    You need git installed on your system to do this. If you've isntalled Parmanode
    the usual way, then you have this already.

    Make a temporary directory somewhere, and navigate into it using Terminal. If 
    you don't understand that, stop, and learn some basic Linux before attempting to
    compile programs; it's too advanced and you won't have a good time.

    From the temporary directory, clone Bitcoin...
$green
        git clone https://github.com/bitcoin/bitcoin.git
$orange
    Then navigate into the new bitconi directory you cloned (${green}cd bitcoin$orange).

    Next, checkout to the version/branch you want. For version 26...
$green
       git checkout v26.0 
$orange    
########################################################################################    
"
enter_continue
;;
4)
set_terminal ; echo -e "
########################################################################################
$cyan
                                  ORDINALS PATCH
$orange
    The ordinals patch is a filter created by Bitcoin Core developer, Luck Dashyr Jr,
    in response to spam from ordinals and inscriptions. Read about it here:
$magenta
    https://bitcoinnews.com/adoption/bitoin-developer-proposes-patch-bitcoin-ordinals/
$orange
    It is important to note that this is not a fork of Bitcoin; it simply allows node
    runners to opt out of receiving and propagating new transactions to and from
    other nodes. It does not stop these transactions from being mine. Once they are
    in a valid block, all compliant Bitcoin nodes (even with a patch) will accept the
    block as valid.

    This patch does NOT stop ordinals. It is purely an INDIVIDUAL choice, not some
    censoring of transactions. Censorship is a whole different discussion.

    To enable the ordinals patch...

########################################################################################
"
enter_continue
set_terminal_high ; echo -e "
########################################################################################

    First create a new brand FROM the desired version of Bitcoin in your local Bitcoin 
    git repository.
$green
        git checkout -b patch
$orange    
    This will create a branch called 'patch' copied from the branch you were in and
    at the same time checkout to that branch.

    Then, download the patch. The following command is all on one line.
$magenta
        curl -LO https://gist.githubusercontent.com/luke-jr/4c022839584020444915c84bdd825831/raw/555c8a1e1e0143571ad4ff394221573ee37d9a56/ filter-ordinals.patch 
$orange
    Then, apply the patch...
$green  
        git apply filter-ordinals.patch
        git add .  $orange #The '.' is necessary and part of the command.$green
        git commit -m "patch"
$orange
    If you get errors from github about usernames and emails, then enter these
    temporary variables as commands. They'll go into the session memory, then try 
    again.
$green
        export GIT_AUTHOR_NAME="Temporary Parmanode"
        export GIT_AUTHOR_EMAIL="parman@parmanode.parman"
        export GIT_COMMITTER_NAME="Parmanode Committer"
        export GIT_COMMITTER_EMAIL="parman@parmanode.parman"
$orange
########################################################################################
"
enter_continue
;;
5)
set_terminal ; echo -e "
########################################################################################
$cyan
                                    AUTOGEN
$orange
    Run this command from the bitcoin directory...
$green
        ./autogen.sh        
$orange
    Pay attention to an errors on the screen, you may have to deal with them.

########################################################################################
"
enter_continue
;;
6)
set_terminal ; echo -e "
########################################################################################
$cyan
                                   CONFIGURE
$orange
    Run the configure command with an options you wish.
$green
        ./configure --with-gui=no
$orange        
    To see a list of the configuration options, do this command first and have a read:
$green
        ./configure --help
$orange
    Again, you need to pay attention to errors.

########################################################################################
"
enter_continue
;;

7)
set_terminal ; echo -e "
########################################################################################
$cyan
                                      MAKE                                
$orange                                    
    Make is the program that will compile the software. But before you use it, check
    how many cores your CPU has.
$green
        nproc
$orange
    You'll get a number in the output. A Pi4 typically has 4 cores. Use that number
    in the make command, which tells it how many cores to use. One core will be slow,
    adding more cores to the compile process will speed things up. Eg...
$green
        make -j 4
$orange
    Check for errors.

########################################################################################
"
enter_continue
;;
8)
set_terminal ; echo -e "
########################################################################################
$cyan
                                   MAKE CHECK
$orange
    This command will perform some tests as written by the Bitcoin developers. Note 
    that if you are applying the ordinals filter patch, some transaction tests will
    fail, as the patch does not modify the standard tests in anyway.
$green
        sudo make -j 4 check
$orange
    Remember to make sure your nubmer in the above command matches your nproc output.
    
    Pay attention for errors.

########################################################################################
"
enter_continue
;;
9)
set_terminal ; echo -e "
########################################################################################
$cyan
                                  MAKE INSTALL
$orange
    This command will move the selected newly created binaries to the target
    directories.
$green
        sudo make install
$orange
    The target directory is$bright_blue /usr/local/bin/ $orange
    
    Once done, check that the files have been moved...
$green    
        which bitcoind bitcoin-cli
$orange
    If you get no ouput, bad new. Something went wrong. If you get /usr/local/bin
    for both files, great success!

########################################################################################
"
enter_continue
;;


*)
;;
esac
done
}