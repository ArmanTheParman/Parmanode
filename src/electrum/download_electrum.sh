function download_electrum {

cd $HOME/parmanode/electrum

choose_electrum_version

if [[ $computer_type == "LinuxPC" ]] ; then
    curl -LO https://download.electrum.org/$electrum_version/electrum-${electrum_version}-x86_64.AppImage && \
    curl -LO https://download.electrum.org/${electrum_version}/electrum-${electrum_version}-x86_64.AppImage.asc && \
    curl -LO https://raw.githubusercontent.com/spesmilo/electrum/master/pubkeys/ThomasV.asc 
    return 0
    fi

if [[ $computer_type == "Pi" ]] ; then
    curl -LO https://download.electrum.org/${electrum_version}/Electrum-${electrum_version}.tar.gz
    curl -LO https://download.electrum.org/${electrum_version}/Electrum-${electrum_version}.tar.gz.asc
    curl -LO https://raw.githubusercontent.com/spesmilo/electrum/master/pubkeys/ThomasV.asc 
    return 0
    fi

# while true ; do
if [[ $OS == Mac ]] ; then
clear 
# echo -e "
# ########################################################################################

#     If you have a Mac with a newer M1/M2 chip, you might run in to problems with
#     the standard Electrum install. If this has happened, or you don't want to take
#     any chances, you can select to install the 'python' version instead. It works
#     the same, you just won'g get a Mac executable in your Applications directory.

#                         1)         Regular install

#                         2)         Python install 

# ########################################################################################
# "
# read choice
# case $choice in 
# 1)
curl -LO https://download.electrum.org/${electrum_version}/electrum-${electrum_version}.dmg && \
curl -LO https://download.electrum.org/${electrum_version}/electrum-${electrum_version}.dmg.asc && \
curl -LO https://raw.githubusercontent.com/spesmilo/electrum/master/pubkeys/ThomasV.asc 
# break
# ;;

# 2)
# export python_install=true
# curl -LO https://download.electrum.org/${electrum_version}/Electrum-${electrum_version}.tar.gz
# curl -LO https://download.electrum.org/${electrum_version}/Electrum-${electrum_version}.tar.gz.asc
# curl -LO https://raw.githubusercontent.com/spesmilo/electrum/master/pubkeys/ThomasV.asc 
# break
# ;;

# *)
# invalid ;;
# esac

# else
#    return
fi

# done

}
function choose_electrum_version {
while true ; do
clear ; echo -e "
########################################################################################
    
               Please indicate your preferred version of Electrum.
$cyan
                                    1)$orange       4.4.4
$cyan
                                    2)$orange       4.5.6 

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main
1)
export electrum_version="4.4.4" 
;;
2)
export electrum_version="4.5.6"
;;
*)
invalid
;;
esac
done

return 0 
}