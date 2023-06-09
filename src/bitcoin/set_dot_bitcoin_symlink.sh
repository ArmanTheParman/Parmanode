function set_dot_bitcoin_symlink {
set_terminal

while true ; do

if [[ $OS == "Linux" && $drive == "internal" ]] ; then
    break
    #no symlink needed
    fi

if [[ $OS == "Linux" && $drive == "external" ]] ; then
    cd $HOME && ln -s /media/$(whoami)/parmanode/.bitcoin/ .bitcoin  && break  #symlink can be made withouterrors even if target doesn't exist yet
    fi

if [[ $OS == "Mac" && $drive == "internal" ]] ; then
    cd $HOME/Library/"Application Support"/ ; rm -rf  Bitcoin
    cd $HOME/Library/"Application Support"/ && ln -s $HOME/.bitcoin Bitcoin && break
    fi

if [[ $OS == "Mac" && $drive == "external" ]] ; then
    cd $HOME/Library/Application\ Support/ ; rm -rf Bitcoin >/dev/null 2>&1 
    cd $HOME ; rm -rf .bitcoin >/dev/null 2>&1 
    cd $HOME/Library/Application\ Support/ && ln -s /Volumes/parmanode/.bitcoin Bitcoin && \
    cd $HOME && ln -s /Volumes/parmanode/.bitcoin .bitcoin && break
    fi
done

if [[ $OS == "Linux" && $drive == "internal" ]] ; then
return 0
fi

set_terminal ; echo "
########################################################################################

                                 
                                 Symlinks created

    NOTHING TO DO, IT'S JUST FOR YOUR INFORMATION IN CASE YOU WANT IT.


    A symlink to the data directory has been created.

        For Linux users with an external drive,
        $HOME/.bitcoin points to
        /media/$(whoami)/parmanode/.bitcoin

        For Mac users with an external drive, 
        $HOME/Library/Application Support/Bitcoin points to 
        /Volumes/parmanode/.bitcoin

        For Mac users with an internal drive, 
        $HOME/Library/Application Support/Bitcoin pionts to 
        $HOME/.bitcoin

########################################################################################
"
enter_continue
return 0
}
